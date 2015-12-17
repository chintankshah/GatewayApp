//
//  SensorsListViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class SensorsListViewController: UIViewController {
    
    var delegate: AnyObject!

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
        
        if(NSStringFromClass(delegate.classForCoder) == NSStringFromClass(HomeViewController.classForCoder())){
            
            backButton.titleLabel?.text = "Back to home"
        }else{
            
            backButton.titleLabel?.text = "View gateway details"
        }
        
    }

    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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

}
