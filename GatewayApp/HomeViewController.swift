//
//  HomeViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var scanButton: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var viewSensorsButton: UIButton!
    
    var timer = NSTimer()
    var deleteMeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.hidden = true
        scanButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadViewFromNib(nibName: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! BackgroundView
        
        view.initializeBackgroundView(UIScreen.mainScreen().bounds, displayLogoTop: true)
        
        return view
    }

    @IBAction func scanAction(sender: AnyObject) {
        
        toggleScan(true)        
    }
    
    @IBAction func viewSensorsAction(sender: AnyObject) {
        
    }
    func toggleScan(isEnabled: Bool){
        
        if(isEnabled){
            
            scanButton.enabled = false
            
            scanButton.backgroundColor = UIColor(red: 65.0/255.0, green: 65.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            scanButton.titleLabel?.textColor = UIColor(red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "deleteMe", userInfo: nil, repeats: true)
            loader.hidden = false
            loader.startAnimating()
            
        }else{
            
            scanButton.enabled = true
            
            scanButton.backgroundColor = UIColor(red: 202.0/255.0, green: 37.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            scanButton.titleLabel?.textColor =  UIColor.whiteColor()
            loader.hidden = true
        }
    }
    
    
    func deleteMe() {
        
        deleteMeCount += 1
        if (deleteMeCount == 3) {
            toggleScan(false)
        }
    }

}
