//
//  RoutesViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 3/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    //    var searchBar: UISearchBar!
    var color: String!
    var stations: [Station] = []
    var routes: [Route] = []
    override func viewDidLoad() {
        super.viewDidLoad()

//        searchBar = UISearchBar()
//        searchBar.sizeToFit()
//        searchBar.showsCancelButton = true
//        searchBar.delegate = self
//        navigationItem.titleView = searchBar
        
        // Do any additional setup after loading the view.
//        fetchBartList()
        fetchBartRoutes()
        yellowButton.layer.cornerRadius = 3
        redButton.layer.cornerRadius = 3
        orangeButton.layer.cornerRadius = 3
        blueButton.layer.cornerRadius = 3
        greenButton.layer.cornerRadius = 3
        yellowButton.tag = 1
        redButton.tag = 2
        orangeButton.tag = 3
        blueButton.tag = 4
        greenButton.tag = 5
        
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        self.tableView.reloadData()
//    }
    
    @IBAction func isClicked(_ sender: Any) {
        print("detect click")
        print("Before segue")
        self.performSegue(withIdentifier: "lineDetailSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (sender as AnyObject).tag
        {
            case 1: print("1")     //when yellow is clicked...
            color = "ffff33"
                break
            case 2: print("2")     //when red is clicked...
            color = "ff0000"
                break
            case 3: print("3")     //when orange is clicked...
            color = "ff9933"
                break
            case 4: print("4")     //when blue is clicked...
            color = "0099cc"
            case 5: print("5")     //when green is clicked...
            color = "339933"
                break
            default: print("Other...")
        }
        
        if segue.identifier == "lineDetailSegue" {
            var routeSelected: Route!
            
            for route in routes{
                if (route.hexcolor == "#"+color){
                    routeSelected = route
                    print("route selected")
                    print(routeSelected.name)
                    break
                }
            }
            
            let lineViewController = segue.destination as! LineViewController
            lineViewController.route = routeSelected
        }
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
                }
            }
        }
        print("end call listBartStations")
    }
    
    func fetchBartRoutes() {
        print("calling listBartRoutes")
        BartAPIManager().listBartRoutes{ (routes: [Route]?, error: Error?) in
            if let routes = routes {
                self.routes = routes
                for route in routes{
                    print(route.hexcolor)
                }
            }
        }
        print("end call listBartRoutes")
    }
}
