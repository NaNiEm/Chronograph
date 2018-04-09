//
//  InitialViewController.swift
//  ChronographApp
//
//  Created by Nancy Gomez on 3/13/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications

class InitialViewController: UIViewController, GMSMapViewDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var selectedPlace: GMSPlace?
    let defaultLocation = CLLocation(latitude: 37.801731, longitude: -122.265008)
    var destinationLocation: CLLocation!
    var destinationStationIndex: Int = 0
    var hasSetAsDestination: [Bool] = []
    var stationName: String = ""
    var isFirstTimeSetting: Bool = true
    @IBOutlet weak var SetDestView: UIView!
    var stations: [Station] = []
    @IBOutlet weak var setOrRemoveDestinationButton: UIButton!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    
    @IBOutlet weak var mapUIView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapUIView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the map to the view, hide it until we've got a location update.
        mapUIView.addSubview(mapView)
        mapView.isHidden = true
        mapView.delegate = self
        fetchBartList()
        
    }
    
    func plotStations(){
        for station in stations {
            // TODO: make Station store CLLocationCoordinate2D or CLLocationDegrees
            let marker = GMSMarker(position: (CLLocationCoordinate2D(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))))
            marker.title = station.name
            marker.snippet = station.address
            marker.map = mapView
            hasSetAsDestination.append(false)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        marker.icon =  self.imageWithImage(image: marker.icon!, scaledToSize: CGSize(width: 3.0, height: 3.0))
        var i = 0
        for station in stations{
            if(marker.position.latitude == CLLocationDegrees(station.latitude) && marker.position.longitude == CLLocationDegrees(station.longitude)){
                if(hasSetAsDestination[i] == true){
                    setOrRemoveDestinationButton.setTitle("Rmv Destination", for: .normal)
                }
                else{
                    setOrRemoveDestinationButton.setTitle("Set Destination", for: .normal)
                }
                stationNameLabel.text = station.name
                stationName = station.name
            }
            i+=1
        }
        mapUIView.addSubview(self.SetDestView)
        SetDestView.isHidden = false
        return true
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x:0, y:0, width: newSize.width, height:newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    //This is only for simulators
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: zoomLevel)
        print(locationManager.location?.coordinate.latitude)
        self.mapView.camera = camera
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        SetDestView.isHidden = true
    }
    
    func fetchBartList() {
        BartAPIManager().listBartStations{ (stations: [Station]?, error: Error?) in
            if let stations = stations {
                self.stations = stations
                self.plotStations()
            }
        }
    }
    
    func setGeoFence(destination: CLLocation){
        print("setting geo fence!")
        //radius is in meters. 130 m == .80 miles away
        let geofenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(destination.coordinate.latitude), CLLocationDegrees(destination.coordinate.longitude)), radius: 130, identifier: "geoFence")
        locationManager.startMonitoring(for: geofenceRegion)
        geofenceRegion.notifyOnEntry = true
        let circle = GMSCircle(position: geofenceRegion.center, radius: geofenceRegion.radius)
        circle.fillColor = UIColor(white:0.7,alpha:0.5)
        circle.strokeWidth = 1;
        circle.strokeColor = UIColor.gray
        circle.map = mapView
        print(geofenceRegion.identifier)
        print(geofenceRegion.center)
    }
    
    func removeGeoFence(destination: CLLocation){
        print("removing geo fence!")
        //radius is in meters. 130 m == .80 miles away
        let geofenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(destination.coordinate.latitude), CLLocationDegrees(destination.coordinate.longitude)), radius: 130, identifier: "geoFence")
        locationManager.stopMonitoring(for: geofenceRegion)
        for region in locationManager.monitoredRegions{
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geofenceRegion.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setDestinationTapped(_ sender: Any) {
        var i = 0
        print("TApping")
        for station in stations{
            if(stationName == station.name){
                if(hasSetAsDestination[i] == false){ //if it's not the current destination
                    if(!isFirstTimeSetting){
                        removeGeoFence(destination: destinationLocation)
                    }
                    self.destinationLocation = CLLocation(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
                    setGeoFence(destination: self.destinationLocation)
                    hasSetAsDestination[i] = true
                    setOrRemoveDestinationButton.setTitle("Rmv Destination", for: .normal)
                    isFirstTimeSetting = false
                }
                else{ //if it has been set as destination
                    hasSetAsDestination[i] = false
                    self.destinationLocation = CLLocation(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
                    removeGeoFence(destination: self.destinationLocation)
                    setOrRemoveDestinationButton.setTitle("Set Destination", for: .normal)
                }
            }
            i += 1
        }
        
    }
    func handleEvent(forRegion region: CLRegion!) {
        
        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = "Get Ready"
        content.body = "Now approaching destination"
        content.sound = UNNotificationSound.default()
        
        // when the notification will be triggered
//        var timeInSeconds: TimeInterval = (60 * 15) // 60s * 15 = 15min
        let timeInSeconds: TimeInterval = 1
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                        repeats: false)
        
        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier
        
        // the notification request object
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        print(content.title)
        print(content.body)
        // trying to add the notification request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.sound)
    }

}

extension InitialViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        let marker = GMSMarker(position: (location.coordinate))
        marker.title = "McDonalds"
        marker.snippet = "1330 Jackson St"
        marker.map = mapView
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // Handle when destination hits user parameter.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print(region.identifier)
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
    }
    
}
