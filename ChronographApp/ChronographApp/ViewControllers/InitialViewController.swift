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

class InitialViewController: UIViewController, GMSMapViewDelegate, locationAlarmDelegate{
    
    let locAlarm = locationAlarm.shared
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 10.0
//    var selectedPlace: GMSPlace?
    let defaultLocation = CLLocation(latitude: 37.7798, longitude: -122.4141)
    var destinationLocation: CLLocation!
    var destinationStationIndex: Int = 0
    var hasSetAsDestination: [Bool] = []
    var stationName: String = ""
    var isFirstTimeSetting: Bool = true
    var polyline: GMSPolyline!
    @IBOutlet weak var SetDestView: UIView!
    var stations: [Station] = []
    var isDestinationSet: Bool = false
    var currLocMarker: GMSMarker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var setOrRemoveDestinationButton: UIButton!
    @IBOutlet weak var stationNameLabel: UILabel!
    //place holder values
    var circle = GMSCircle(position: CLLocationCoordinate2D(latitude: 37.801731, longitude: -122.265008), radius: 130)
    @IBOutlet weak var mapUIView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locAlarm.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUIMapView(notification:)), name: NSNotification.Name(rawValue: "settingUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentLocationUpdated(notification:)), name: NSNotification.Name(rawValue: "updateCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertUser(notification:)), name: NSNotification.Name(rawValue: "StartAlarm"), object: nil)
        print("Finished Setting Up Alarm")
        NotificationCenter.default.addObserver(self, selector: #selector(alertUserToChangeNotifSettings(notification:)), name: NSNotification.Name(rawValue: "DeniedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertUserToChangeLocationSettings(notification:)), name: NSNotification.Name(rawValue: "DeniedLocationAccess"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(alertUserToIncreaseVolume(notification:)), name: NSNotification.Name(rawValue: "Volume"), object: nil)
        activityIndicator.startAnimating()
        
        SetDestView.isHidden = true
        
        placesClient = GMSPlacesClient.shared() // ?
    }
    
    @objc func setUIMapView(notification: NSNotification){
        
        SetDestView.layer.cornerRadius = 3
        setOrRemoveDestinationButton.layer.cornerRadius = 10
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapUIView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the map to the view, hide it until we've got a location update.
        mapUIView.addSubview(mapView)
        mapView.delegate = self
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        fetchBartList()
    }
    
    @objc func alertUserToChangeNotifSettings(notification: NSNotification){
        locAlarm.isNotificationEnabled = false
        let alert = UIAlertController(title: "Change Notification Settings", message: "Enable notifications for Chronograph to run properly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAlarm"), object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//    @objc func alertUserToIncreaseVolume(notification: NSNotification){
//        
//    }
    
    @objc func alertUserToChangeLocationSettings(notification: NSNotification){
        let alert = UIAlertController(title: "Change Location Settings", message: "Allow location access and reopen Chronograph for it to run properly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAlarm"), object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func currentLocationUpdated(notification: NSNotification){
//        currLocMarker = GMSMarker(position: (currentLocation?.coordinate)!)
//        currLocMarker.title = "currLoc"
//        currLocMarker.icon = UIImage(named: "circle")
//        currLocMarker.snippet = "user's location"
//        currLocMarker.map = mapView
        if (!isFirstTimeSetting){
//            currLocMarker.map = nil
        }
        if (isFirstTimeSetting && isDestinationSet){
            getPolylineRoute(from: (locAlarm.getCurrentLocation()), to: destinationLocation.coordinate)
        }
        else if (isDestinationSet){
            removePath()
//            currLocMarker.map = nil
            getPolylineRoute(from: (locAlarm.getCurrentLocation()), to: destinationLocation.coordinate)
        }
    }
    
    func plotStations(){
        for station in stations {
            // TODO: make Station store CLLocationCoordinate2D or CLLocationDegrees
            let marker = GMSMarker(position: (CLLocationCoordinate2D(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))))
            marker.title = station.name
            marker.icon = UIImage(named: "pin")
            marker.snippet = station.address
            marker.map = mapView
            hasSetAsDestination.append(false)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if(!locAlarm.isNotificationEnabled){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeniedNotification"), object: nil)
        }
        else{
            var i = 0
            for station in stations{
                if(marker.position.latitude == CLLocationDegrees(station.latitude) && marker.position.longitude == CLLocationDegrees(station.longitude)){
                    if(hasSetAsDestination[i] == true){
                        setOrRemoveDestinationButton.setTitle("Remove", for: .normal)
                    }
                    else{
                        setOrRemoveDestinationButton.setTitle("Set", for: .normal)
                    }
                    stationNameLabel.text = station.name
                    stationName = station.name
                    
                    mapUIView.addSubview(self.SetDestView)
                    SetDestView.isHidden = false
                }
                i+=1
            }
        }
        return true
    }
    
    //This is only for simulators
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let camera = GMSCameraPosition.camera(withLatitude: (locAlarm.getCurrentLocation().latitude),
                                              longitude: (locAlarm.getCurrentLocation().longitude),
                                              zoom: zoomLevel)

        print(locAlarm.getLocationManager().location?.coordinate.latitude)
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
        hasSetAsDestination[destinationStationIndex] = true
//        print("setting geo fence!")
        //radius is in meters. 130 m == .80 miles away
        let geofenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(destination.coordinate.latitude), CLLocationDegrees(destination.coordinate.longitude)), radius: 130, identifier: "geoFence")
        locAlarm.getLocationManager().startMonitoring(for: geofenceRegion)
        geofenceRegion.notifyOnEntry = true
        circle = GMSCircle(position: geofenceRegion.center, radius: geofenceRegion.radius)
        circle.fillColor = UIColor(white:0.7,alpha:0.5)
        circle.strokeWidth = 1;
        circle.strokeColor = UIColor.gray
        circle.map = mapView
        print(geofenceRegion.center)
    }

    func removeGeoFence(destination: CLLocation){
        print("removing geo fence!")
        hasSetAsDestination[destinationStationIndex] = false
        //radius is in meters. 130 m == .80 miles away
        let geofenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(CLLocationDegrees(destination.coordinate.latitude), CLLocationDegrees(destination.coordinate.longitude)), radius: 130, identifier: "geoFence")
        circle.map = nil
        locAlarm.getLocationManager().stopMonitoring(for: geofenceRegion)
        removePath()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setDestinationTapped(_ sender: Any) {
        var i = 0
//        print("Tapping")
        for station in stations{
            if(stationName == station.name){
                if(hasSetAsDestination[i] == false){ //if it's not the current destination
                    if(!isFirstTimeSetting){ //if it already has a destination set before this
                        removeGeoFence(destination: destinationLocation)
                        removePath()
                    }
                    isDestinationSet = true
                    destinationStationIndex = i
                    self.destinationLocation = CLLocation(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
                    setGeoFence(destination: self.destinationLocation)
                    setOrRemoveDestinationButton.setTitle("Remove", for: .normal)
                    isFirstTimeSetting = false
                    let destination = destinationLocation.coordinate
                    let origin = defaultLocation.coordinate
                    self.getPolylineRoute(from: origin, to: destination)
                }
                else{ //if it has been set as destination
                    self.destinationLocation = CLLocation(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
                    removeGeoFence(destination: self.destinationLocation)
                    destinationLocation = nil
                    setOrRemoveDestinationButton.setTitle("Set", for: .normal)
                    isFirstTimeSetting = true
                    isDestinationSet = false
                }
            }
            i += 1
        }
    }

    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=transit&transit_mode=train&key=AIzaSyAR-HPSnLwn4pdl_KjzNvuJ7KmWkM4yoDY")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
//                        print(json)
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
//                        print("printing routes")
//                        print(routes)
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary

                            let points = dictPolyline?.object(forKey: "points") as? String
//                            print("printing points")
//                            print(points!)
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
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: polyStr)
            self.polyline = GMSPolyline(path: path)
            self.polyline.strokeWidth = 3.0
            self.polyline.strokeColor = UIColor.red
            self.polyline.map = self.mapView // Your map view
        }
    }

    func removePath(){
        polyline.map = nil
    }
    

    @objc func alertUser(notification: NSNotification){
        print("ALARM")
        let alert = UIAlertController(title: "Wake Up!", message: "Pack up and get ready to get off the upcoming station.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAlarm"), object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //added for protocol
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
    }

}
