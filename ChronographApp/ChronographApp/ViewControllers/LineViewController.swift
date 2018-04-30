//
//  LineViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 4/21/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class LineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var route: Route!
    var stations: [Station] = []
    var routeInfo: [RouteInfo]!
    var stationsToPrint: [Station] = []
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // setting up activity indicator
        self.activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LineViewController.didPullToRefresh(_:) ), for: . valueChanged)
        didPullToRefresh(refreshControl)
        tableView.insertSubview(refreshControl, at: 0)
        
        // set up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPullToRefresh(_ refreshControl:  UIRefreshControl){
        fetchRouteInfo() {() -> () in
            fetchBartList()
        }
        refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
    }
    
    func fetchRouteInfo(completion: () -> ()){
        print("calling getRouteInfo")
        BartAPIManager().listBartRouteInfo(routeNum: route.number) { (routeInfo: [RouteInfo]?, error: Error?) in
            if let routeInfo = routeInfo {
                self.routeInfo = routeInfo
                print(routeInfo)
            }
        }
        print("end call getRouteInfo")
        completion()
        
    }
    
    func fetchBartList() {
        print("calling listBartStations")
        BartAPIManager().listBartStations{ (stations: [Station]?, error: Error?) in
            if let stations = stations {
                for station in stations{
                    if self.routeInfo[0].stations.contains(station.abbr){
                        self.stations.append(station)
                    }
                }
                print(stations)
            }
        }
        print("end call listBartStations")
        self.tableView.reloadData()
    }
    
//    func printStationsInRoute(){
//        for station in stations{
//            if routeInfo[0].stations.contains(station.abbr){
//                stationsToPrint.append(station)
//            }
//        }
//        self.tableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell

        cell.station = stations[indexPath.row]
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
