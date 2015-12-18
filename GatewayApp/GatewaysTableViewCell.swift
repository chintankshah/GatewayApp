//
//  GatewaysTableViewCell.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/18/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class GatewaysTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected){
            self.wrapperView.backgroundColor = UIColor(red:202.0/255.0, green:37.0/255.0, blue:50.0/255.0, alpha:1.0)
            self.title.font = UIFont.systemFontOfSize(23.0)
            self.title.textColor = UIColor.whiteColor()
            
        }else{
            self.wrapperView.backgroundColor = UIColor.whiteColor()
            self.title.font = UIFont.systemFontOfSize(20.0)
            self.title.textColor = UIColor(red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        }
    }
    
}
