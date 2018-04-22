//
//  StationTableViewCell.swift
//  ChronographApp
//
//  Created by Emily Garcia on 3/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {
    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var route: Route! {
        didSet {
            nameLabel.text = route.name
//            addressLabel.text = route.a
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
