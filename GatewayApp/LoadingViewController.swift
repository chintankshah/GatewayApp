//
//  LoadingViewController.swift
//  BLETransferPOC
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var backgroundViewHolder: UIView!
    
    var window: UIWindow?
    var timer = NSTimer()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundViewHolder.addSubview(backgroundView)

        loader.startAnimating()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countUp", userInfo: nil, repeats: true)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
    }
    
    func loadViewFromNib(nibName: String) -> UIView {
    
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! BackgroundView
        
        view.initializeBackgroundView(UIScreen.mainScreen().bounds, displayLogoTop: false)
        
        return view
    }
    
    func countUp() {
        
        count += 1
        if (count == 2) {
            timer.invalidate()
            displayHome()
        }
    }
    
    func displayHome(){
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let navigationController = UINavigationController()
            
            navigationController.navigationBar.hidden = true;
            
            let mainView = HomeViewController(nibName: "HomeViewController", bundle: nil)
            navigationController.viewControllers = [mainView]
            
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


