//
//  Station.swift
//  ChronographApp
//
//  Created by Nancy Gomez on 3/26/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation

class Station {
    var latitude: Float;
    var longitude: Float;
    var name: String;
    var abbr: String;
    var address: String;
    var city: String;
    var county: String;
    var state: String;
    var zipcode: String;
    
    
    
    init() {
        // Bart SF
        latitude = 37.615963
        longitude = -122.392415
        name = "SF Bart"
        abbr = "sfbart"
        address = "111 fake st"
        city = "Faketown"
        county = "Fake af"
        state = "FK"
        zipcode = "1337"
    }
    
    init(latitude: Float, longitude: Float, name: String, abbr: String, address: String, city: String,
         county: String, state: String, zipcode: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.abbr = abbr
        self.address = address
        self.city = city
        self.county = county
        self.state = state
        self.zipcode = zipcode
    }
    
    init(dict: [String: Any]) {
        latitude = (dict["gtfs_latitude"] as! NSString).floatValue
        longitude = (dict["gtfs_longitude"] as! NSString).floatValue
        name = dict["name"] as! String
        abbr = dict["abbr"] as! String
        address = dict["address"] as! String
        city = dict["city"] as! String
        county = dict["county"] as! String
        state = dict["state"] as! String
        zipcode = dict["zipcode"] as! String
    }
    
    class func stations(dicts: [[String: Any]]) -> [Station] {
        var stations: [Station] = []
        for dict in dicts {
            let station = Station(dict: dict)
            print("station: ", station)
            stations.append(station)
        }
        
        return stations
    }
}
