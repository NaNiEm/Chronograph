//
//  locationAlarm.swift
//  ChronographApp
//
//  Created by Nicole Hipolito on 4/21/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import AVFoundation

protocol locationAlarmDelegate {
    func locationDidUpdateToLocation(location : CLLocation)
}

class locationAlarm: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    static let shared = locationAlarm()
    private var locationManager = CLLocationManager()
    var audioPlayer:AVAudioPlayer!
    var currentLocation: CLLocation?
    var delegate : locationAlarmDelegate!
    private var isFirstTimeSettingUp: Bool = true
    
    private override init () {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopAudio(notification:)), name: NSNotification.Name(rawValue: "StopAlarm"), object: nil)
        
        //Setting audio to be played when inside the geofence
        var audioFilePath = Bundle.main.path(forResource: "Hungaria", ofType: "mp3")
        if audioFilePath != nil {
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl)
            }
            catch{
                audioFilePath = nil
                print("Error with music")
            }
        } else {
            print("audio file is not found")
        }
        
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location
        if(isFirstTimeSettingUp){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingUp"), object: nil)
            isFirstTimeSettingUp = false
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCurrentLocation"), object: nil)
        }
        
        DispatchQueue.main.async() { () -> Void in
            self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
        }
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D{
        return (currentLocation?.coordinate)!
    }
    
    @objc func stopAudio(notification: NSNotification){
        audioPlayer.stop()
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        
        // customize your notification content
        let state = UIApplication.shared.applicationState
        // if the app is running in the background, send local push notif
        if state == .background {
            
            // customize your notification content
            let content = UNMutableNotificationContent()
            content.title = "Get Ready"
            content.body = "Now approaching destination"
            content.sound = UNNotificationSound.default()
            
            // when the notification will be triggered
            let timeInSeconds: TimeInterval = 0.1
            // the actual trigger object
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                            repeats: false)
            
            // notification unique identifier, for this example, same as the region to avoid duplicate notifications
            let identifier = region.identifier
            
            // the notification request object
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            // trying to add the notification request to notification center
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartAlarm"), object: nil)
        audioPlayer.play()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.sound)
    }

    // let user use location manager.
    func getLocationManager() -> CLLocationManager{
        return locationManager
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            // TODO: SET ALERT TO TELL USER TO FIX IT
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeniedNotification"), object: nil)
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
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
    }
}
