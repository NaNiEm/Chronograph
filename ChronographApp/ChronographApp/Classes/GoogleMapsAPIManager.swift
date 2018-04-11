//
//  GoogleMapsAPIManager.swift
//  ChronographApp
//
//  Created by Nancy Gomez on 3/13/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleMapsAPIManager {
//    var session: URLSession
//
//    init() {
//        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//    }
//
//    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
//
//        let url = URL(string:"https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyCsiXLRfeicvlewhtRuHf0VnTNf4g5InLE")!
//
//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//            if error != nil {
//                completion(nil, error)
////                print(error!.localizedDescription)
////                self.activityIndicator.stopAnimating()
//            }
//            else {
//                do {
//                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
//
//                        guard let routes = json["routes"] as? NSArray else {
//                            DispatchQueue.main.async {
////                                self.activityIndicator.stopAnimating()
//                            }
//                            return
//                        }
//                        completion(routes, nil)
//                        if (routes.count > 0) {
//                            let overview_polyline = routes[0] as? NSDictionary
//                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
//
//                            let points = dictPolyline?.object(forKey: "points") as? String
//
//                            self.showPath(polyStr: points!)
//
//                            DispatchQueue.main.async {
////                                self.activityIndicator.stopAnimating()
//
//                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
//                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
//                                self.mapView!.moveCamera(update)
//                            }
//                        }
//                        else {
//                            DispatchQueue.main.async {
////                                self.activityIndicator.stopAnimating()
//                            }
//                        }
//                    }
//                }
//                catch {
//                    print("error in JSONSerialization")
//                    DispatchQueue.main.async {
////                        self.activityIndicator.stopAnimating()
//                    }
//                }
//            }
//        })
//        task.resume()
//    }
//
//    func showPath(polyStr :String){
//        let path = GMSPath(fromEncodedPath: polyStr)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 3.0
//        polyline.strokeColor = UIColor.red
//        polyline.map = mapView // Your map view
//    }
}
