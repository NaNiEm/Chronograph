//
//  BartAPIManager.swift
//  ChronographApp
//
//  Created by Nancy Gomez on 3/26/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation

class BartAPIManager {
    static let baseURLStn = "http://api.bart.gov/api/stn.aspx?"
    static let baseURLRoute = "http://api.bart.gov/api/route.aspx?"
    
    static let apiKey = "QSBV-PVEA-9KET-DWE9"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func listBartStations(completion: @escaping ([Station]?, Error?) -> ()) {
        // link for list of BART stations (JSON) : http://api.bart.gov/api/stn.aspx?cmd=stns&key=QSBV-PVEA-9KET-DWE9&json=y
        let url = URL(string: BartAPIManager.baseURLStn + "cmd=stns&key=\(BartAPIManager.apiKey)&json=y")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let rawDict = dataDict["root"] as! [String: Any]
                let stationInfo = rawDict["stations"] as! [String: Any]
                let stationList = stationInfo["station"] as! [[String: Any]]
                let stations = Station.stations(dicts: stationList)
                completion(stations, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func listBartRoutes(completion: @escaping ([Route]?, Error?) -> ()) {
        // link for list of BART stations (JSON) : http://api.bart.gov/api/route.aspx?cmd=routes&key=QSBV-PVEA-9KET-DWE9&json=y
        let url = URL(string: BartAPIManager.baseURLRoute + "cmd=routes&key=\(BartAPIManager.apiKey)&json=y")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let rawDict = dataDict["root"] as! [String: Any]
                
                let routeList = rawDict["routes"] as! [String: Any]
                let route = routeList["route"] as! [[String: Any]]
                let routes = Route.routes(dicts: route)
                completion(routes, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    func listBartStationsInRoute(completion: @escaping ([Route]?, Error?) -> ()) {
        // link for list of BART stations (JSON) : http://api.bart.gov/api/route.aspx?cmd=routeInfo&key=QSBV-PVEA-9KET-DWE9&json=y
        let url = URL(string: BartAPIManager.baseURLRoute + "cmd=routeInfo&key=\(BartAPIManager.apiKey)&json=y")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let rawDict = dataDict["root"] as! [String: Any]
                
                let routeList = rawDict["routes"] as! [String: Any]
                let route = routeList["route"] as! [[String: Any]]
                let routes = Route.routes(dicts: route)
                completion(routes, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
