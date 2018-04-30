//
//  RouteInfo.swift
//  ChronographApp
//
//  Created by Emily Garcia on 4/29/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation

class RouteInfo {
    var name: String
    var abbr: String
    var routeID: String
    var number: String
    var stations: [String]
   
    init(name: String, abbr: String, routeID: String, number: String,
         stations: [String]) {
        self.name = name
        self.abbr = abbr
        self.routeID = routeID
        self.number = number
        self.stations = stations
    }
    
    init(dict: [String: Any]) {
        name = dict["name"] as! String
        abbr = dict["abbr"] as! String
        routeID = dict["routeID"] as! String
        number = dict["number"] as! String
        let config = dict["config"] as! [String: Any]
        stations = config["station"] as! [String]
    }
    
    class func allRoutesInfo(dicts: [[String: Any]]) -> [RouteInfo] {
        var allInfo: [RouteInfo] = []
        for dict in dicts {
            let routeInfo = RouteInfo(dict: dict)
            //                        print("station name: ", station.name)
            allInfo.append(routeInfo)
        }
        
        return allInfo
    }
    
}
