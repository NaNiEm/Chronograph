//
//  LineViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 4/21/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class LineViewController: UIViewController {
    
    var route: Route!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(route)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
