//
//  SensorsTableViewCell.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/18/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class SensorsTableViewCell: UITableViewCell {

    @IBOutlet var sensorTitle: UILabel!
    @IBOutlet var sensorIcon: UIImageView!
    
    @IBOutlet var field1: UILabel!
    @IBOutlet var field2: UILabel!
    @IBOutlet var field3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
