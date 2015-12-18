//
//  SensorsTableHeaderView.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/18/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class SensorsSectionHeaderView: UIView {
    
    @IBOutlet var title: UILabel!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeBackgroundView(frame : CGRect, sensorTitle value : String){
        
        title.text = value
    }
    
}
