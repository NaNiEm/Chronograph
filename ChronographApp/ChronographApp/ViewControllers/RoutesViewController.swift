//
//  RoutesViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 3/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var stations: [Station] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        fetchBartList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchBartList() {
        print("calling listBartStations")
        BartAPIManager().listBartStations{ (stations: [Station]?, error: Error?) in
            if let stations = stations {
                self.stations = stations
                for station in stations{
                    self.tableView.reloadData()
                }
            }
        }
        print("end call listBartStations")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as! StationTableViewCell
        
        cell.station = stations[indexPath.row]
        
        return cell
    }
}
