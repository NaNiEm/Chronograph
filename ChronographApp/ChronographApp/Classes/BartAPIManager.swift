//
//  BartAPIManager.swift
//  ChronographApp
//
//  Created by Nancy Gomez on 3/26/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation

class BartAPIManager {
    static let baseURL = "http://api.bart.gov/api/stn.aspx?"
    static let apiKey = "QSBV-PVEA-9KET-DWE9"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func listBartStations(completion: @escaping ([Station]?, Error?) -> ()) {
        print("Start Bart API Call")
        // link for list of BART stations (JSON) : http://api.bart.gov/api/stn.aspx?cmd=stns&key=QSBV-PVEA-9KET-DWE9&json=y
        let url = URL(string: BartAPIManager.baseURL + "cmd=stns&key=\(BartAPIManager.apiKey)&json=y")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let rawDict = dataDict["root"] as! [String: Any]
                let stationInfo = rawDict["stations"] as! [String: Any]
                let stationList = stationInfo["station"] as! [[String: Any]]
                let stations = Station.stations(dicts: stationList)
                for station in stations {
                    print("Station in let data = data")
                    print(station.name)
                }
                completion(stations, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
        print("End Bart API Call")
    }
    
}
