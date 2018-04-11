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
    var stationName: String = ""
    @IBOutlet weak var SetDestView: UIView!
    var stations: [Station] = []
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapUIView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
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
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: -33.85, longitude: 151.20))
        path.add(CLLocationCoordinate2D(latitude: -33.70, longitude: 151.40))
        path.add(CLLocationCoordinate2D(latitude: -33.73, longitude: 151.41))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
    }
    func plotStations(){
        for station in stations {
            // TODO: make Station store CLLocationCoordinate2D or CLLocationDegrees
            let marker = GMSMarker(position: (CLLocationCoordinate2D(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))))
            marker.title = station.name
            marker.snippet = station.address
            marker.map = mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        marker.icon =  self.imageWithImage(image: marker.icon!, scaledToSize: CGSize(width: 3.0, height: 3.0))
        for station in stations{
            if(marker.position.latitude == CLLocationDegrees(station.latitude) && marker.position.longitude == CLLocationDegrees(station.longitude)){
                stationName = station.name
            }
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
    
    func setGeoFence(station: Station){
        //radius is in meters. 130 m == .80 miles away
        let geofenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(station.latitude), CLLocationDegrees(station.longitude)), radius: 130, identifier: "geoFence")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setDestinationTapped(_ sender: Any) {
        for station in stations{
            if(stationName == station.name){
                setGeoFence(station: station)
                let destination = CLLocationCoordinate2D(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
                let source = defaultLocation.coordinate
                print("printing source and destination")
                print(source)
                print(destination)
                getPolylineRoute(from: source, to: destination)
            }
        }
        
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=transit&key=AIzaSyAR-HPSnLwn4pdl_KjzNvuJ7KmWkM4yoDY")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        print(json)
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        print("printing routes")
                        print(routes)
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            print("printing points")
                            print(points!)
                            self.showPath(polyStr: points!)
                            
                            DispatchQueue.main.async {
//                                self.activityIndicator.stopAnimating()
                                
                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                self.mapView!.moveCamera(update)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10.0
        polyline.strokeColor = UIColor.red
        polyline.map = mapView // Your map view
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
