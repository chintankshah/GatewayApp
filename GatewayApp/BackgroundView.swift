//
//  BackgroundView.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    

    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeBackgroundView(frame : CGRect, displayLogoTop value : Bool){
        
        if(value){
            topConstraint.constant = 0
        }
        else{
            topConstraint.constant = (frame.size.height/2)-(logo.frame.height/2)
        }
        
        initBackgroundView()
    }
    
    func initBackgroundView(){
        
        var launchImageName = String();
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone)
        {
            let screenHeight = UIScreen.mainScreen().bounds.size.height;
            
            if (screenHeight == 568) {
                launchImageName = "Default-568h@2x.png"; // iPhone 5/5s, 4.0 inch screen
            }
            else if (screenHeight == 667){
                launchImageName = "Default-667h@2x.png"; // iPhone 6/6s, 4.7 inch screen
            }
            else if (screenHeight == 736){
                launchImageName = "Default-Portrait-736h@3x.png"; // iPhone 6+/6s+, 5.5 inch screen
            }
            else{
                launchImageName = "Default@2x.png"; // iPhone 4/4s, 3.5 inch screen
            }
            
            backgroundView.image = UIImage(named:launchImageName);
        }

        
    }
    

}
