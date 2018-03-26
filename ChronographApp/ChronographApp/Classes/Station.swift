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
    
    init() {
        // Bart SF
        latitude = 37.615963;
        longitude = -122.392415;
    }
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
}
