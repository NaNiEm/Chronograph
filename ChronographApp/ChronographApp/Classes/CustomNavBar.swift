//
//  CustomNavBar.swift
//  ChronographApp
//
//  Created by Emily Garcia on 4/21/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // do whatever custom setup stuff you want here
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = uicolorFromHex(rgbValue: 0xF6F6FF)
        
    }
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    // override other methods for different customizations

}
