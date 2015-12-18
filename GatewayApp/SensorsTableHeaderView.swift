//
//  SensorsTableHeaderView.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/18/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class SensorsTableHeaderView: UIView {

    @IBOutlet var noOfSensors: UILabel!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeView(frame: CGRect, noOfSensors value : String){
        
        self.bounds = frame
        self.frame = frame
        noOfSensors.text = value
    }
    
}
