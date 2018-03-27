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
        self.latitude = latitude;
        self.longitude = longitude;
        self.name = name;
        self.abbr = abbr;
        self.address = address;
        self.city = city;
        self.county = county;
        self.state = state;
        self.zipcode = zipcode;
    }
}
