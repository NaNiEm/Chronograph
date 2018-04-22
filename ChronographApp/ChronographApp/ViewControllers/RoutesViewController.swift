//
//  RoutesViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 3/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController {
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    var color: String!
    var stations: [Station] = []
    var routes: [Route] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        fetchBartList()
        fetchBartRoutes()
        yellowButton.tag=1
        orangeButton.tag=2
        blueButton.tag=3
        greenButton.tag=4
        
    }
    
    @IBAction func isClicked(_ sender: Any) {
        print("detect click")
        print("Before segue")
        self.performSegue(withIdentifier: "lineDetailSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (sender as AnyObject).tag
        {
            case 1: print("1")     //when Button1 is clicked...
            color = "ffff33"
                break
            case 2: print("2")     //when Button2 is clicked...
            color = "ff9933"
                break
            case 3: print("3")     //when Button3 is clicked...
            color = "0099cc"
                break
            case 4: print("4")     //when Button4 is clicked...
            color = "339933"
                break
            default: print("Other...")
        }
        
        if segue.identifier == "lineDetailsSegue" {
            var routeSelected: Route!
            
            for route in routes{
                if (route.hexcolor == "#"+color){
                    routeSelected = route
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
