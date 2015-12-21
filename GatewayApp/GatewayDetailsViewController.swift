//
//  GatewayDetailsViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/19/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class GatewayDetailsViewController: UIViewController, ModalDelegate {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var gatewayId: LeftPaddingLabel!
    @IBOutlet var numberOfSensors: LeftPaddingLabel!
    @IBOutlet var WANStatus: LeftPaddingLabel!
    @IBOutlet var disconnectWANButton: UIButton!
    @IBOutlet var WANConnectionSettingButton: UIButton!
    @IBOutlet var WANConnectionButton: UIButton!
    @IBOutlet var viewSensorsButton: UIButton!
    @IBOutlet var modalHolder: UIView!
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewSensorsAction(sender: AnyObject) {
        
        let sensorsListController = SensorsListViewController(nibName: "SensorsListViewController", bundle: nil)
        sensorsListController.delegate = self;
        
        self.navigationController?.pushViewController(sensorsListController, animated: true)
    }
    
    
    @IBAction func closeGatewayConnection(sender: AnyObject) {
        
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
    
    @IBAction func disconnectWANAction(sender: AnyObject) {
        
        self.WANStatus.backgroundColor = UIColor(red: 202.0/255.0, green: 37.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        self.WANStatus.text = "Not Connected"
        
        self.disconnectWANButton.hidden = true
        self.WANConnectionButton.hidden = false
        self.WANConnectionSettingButton.hidden = false
    }
    
    @IBAction func connectToWANAction(sender: AnyObject) {
        
        
        let modalView = loadModalView("ModalView") as! ModalView
        modalView.delegate = self
        modalView.initializeModal("Connecting..", modalType: ModalType.LoaderWithoutButtonAndClose)
        modalHolder.addSubview(modalView)
        modalHolder.hidden = false
        
        let delayInSeconds = 3.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            
            self.WANStatus.backgroundColor = UIColor(red: 89.0/255.0, green: 203.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            self.WANStatus.text = "Connected"
            
            self.disconnectWANButton.hidden = false
            self.WANConnectionButton.hidden = true
            self.WANConnectionSettingButton.hidden = true
            
            self.modalHolder.hidden = true
            for view in self.modalHolder.subviews{
                view.removeFromSuperview()
            }
        }
        
    }

    @IBAction func wanSettingAction(sender: AnyObject) {
        
    }
   
}

// MARK: - Helper Functions

extension GatewayDetailsViewController{
    
    func loadViewFromNib(nibName: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! BackgroundView
        
        view.initializeBackgroundView(UIScreen.mainScreen().bounds, displayLogoTop: true)
        
        return view
    }
    
    func loadModalView(nibName: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! ModalView
        
        let frame = UIScreen.mainScreen().bounds
        view.frame = frame
        
        return view
    }
}
