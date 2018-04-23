//
//  Routes.swift
//  ChronographApp
//
//  Created by Emily Garcia on 4/21/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation

class Route {
    var name: String;
    var abbr: String;
    var routeID: String;
    var number: String;
    var hexcolor: String;
    
    init(name: String, abbr: String, routeID: String, number: String,
         hexcolor: String) {
        self.name = name
        self.abbr = abbr
        self.routeID = routeID
        self.number = number
        self.hexcolor = hexcolor
    }
    
    init(dict: [String: Any]) {
        name = dict["name"] as! String
        abbr = dict["abbr"] as! String
        routeID = dict["routeID"] as! String
        number = dict["number"] as! String
        hexcolor = dict["hexcolor"] as! String
    }
    
    class func routes(dicts: [[String: Any]]) -> [Route] {
        var routes: [Route] = []
        for dict in dicts {
            let route = Route(dict: dict)
//                        print("station name: ", station.name)
            routes.append(route)
        }
        
        return routes
    }
}
