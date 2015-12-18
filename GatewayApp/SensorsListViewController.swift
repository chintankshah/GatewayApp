//
//  SensorsListViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class SensorsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: AnyObject!

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var sensorsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
        
        if(NSStringFromClass(delegate.classForCoder) == NSStringFromClass(HomeViewController.classForCoder())){
            
            backButton.titleLabel?.text = "Back to home"
        }else{
            
            backButton.titleLabel?.text = "View gateway details"
        }
        
        sensorsTableView.backgroundColor = UIColor.clearColor()
        
        
        print("UIScreen.mainScreen().bounds.width: ", UIScreen.mainScreen().bounds.width)
        
        let nibName = UINib(nibName: "SensorsTableViewCell", bundle:nil)
        sensorsTableView.registerNib(nibName, forCellReuseIdentifier: "SensorsTableViewCell")
        
        let sensorTableHeader = loadViewTableHeader("SensorsTableHeaderView", noOfSensors: "15 sensor objects found")
        
        sensorsTableView.tableHeaderView = sensorTableHeader
        
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
    
    func loadViewSesctionHeader(nibName: String, sensorTitle: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! SensorsSectionHeaderView
        
        view.initializeBackgroundView(UIScreen.mainScreen().bounds, sensorTitle: sensorTitle)
        
        return view
    }
    
    func loadViewTableHeader(nibName: String, noOfSensors: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! SensorsTableHeaderView
        
        let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200)
        
        view.frame = frame

        view.initializeView(frame, noOfSensors: noOfSensors)
        
        return view
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SensorsTableViewCell", forIndexPath: indexPath) as! SensorsTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = "Sensor Title"
        let sectionHeader = loadViewSesctionHeader("SensorsSectionHeaderView", sensorTitle: title)
        return sectionHeader
    }
    
    

}
