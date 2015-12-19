//
//  HomeViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/17/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, ModalDelegate{

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var scanButton: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var viewSensorsButton: UIButton!
    
    @IBOutlet var homeWrapper: UIView!
    @IBOutlet var gatewayListWrapper: UIView!
    @IBOutlet var gatewayListTableView: UITableView!
    @IBOutlet var modalHolder: UIView!
    
    var timer = NSTimer()
    var deleteMeCount = 0
    var refreshControl: UIRefreshControl!
    var centralManager: CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.hidden = true
        scanButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
    
        gatewayListTableView.backgroundColor = UIColor.clearColor()
        
        //Registering cell
        let nibName = UINib(nibName: "GatewaysTableViewCell", bundle:nil)
        gatewayListTableView.registerNib(nibName, forCellReuseIdentifier: "GatewaysTableViewCell")

        //Table Header
        let sensorTableHeader = loadViewTableHeader("SensorsTableHeaderView")
        gatewayListTableView.tableHeaderView = sensorTableHeader
        
        //Refresh controller
        refreshControl = UIRefreshControl()
        refreshControl.bounds = CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, 60)
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        gatewayListTableView.addSubview(refreshControl)
        
        self.gatewayListWrapper.hidden = true
        self.homeWrapper.hidden = false
        
        //Bluetooth
        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func refresh(sender:AnyObject){
        
        let delayInSeconds = 3.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.refreshControl!.endRefreshing()
        }
        
    }
    
    @IBAction func scanAction(sender: AnyObject) {
        
        toggleScan(true)        
    }
    
    @IBAction func viewSensorsAction(sender: AnyObject) {
        
        let sensorsListController = SensorsListViewController(nibName: "SensorsListViewController", bundle: nil)
        sensorsListController.delegate = self;
        
        self.navigationController?.pushViewController(sensorsListController, animated: true)
    }
    
}

// MARK: - Helper Functions

extension HomeViewController{
    
    func loadViewFromNib(nibName: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! BackgroundView
        
        view.initializeBackgroundView(UIScreen.mainScreen().bounds, displayLogoTop: true)
        
        return view
    }
    
    func loadViewTableHeader(nibName: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! SensorsTableHeaderView
        
        let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200)
        view.frame = frame
        
        view.noOfSensors.hidden = true
        
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
    
    func toggleScan(isEnabled: Bool){
        
        if(isEnabled){
            
            
            scanButton.setTitle("Scanning for\ngateways...", forState: UIControlState.Normal)
            scanButton.backgroundColor = UIColor(red: 65.0/255.0, green: 65.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            scanButton.setTitleColor(UIColor(red: 121.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            scanButton.enabled = false
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "deleteMe", userInfo: nil, repeats: true)
            loader.hidden = false
            loader.startAnimating()
            
        }else{
            
            scanButton.enabled = true
            scanButton.setTitle("Scan for\ngateways", forState: UIControlState.Normal)
            scanButton.backgroundColor = UIColor(red: 202.0/255.0, green: 37.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            scanButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            loader.hidden = true
            deleteMeCount = 0
        }
    }
    
    
    func deleteMe() {
        
        deleteMeCount += 1
        if (deleteMeCount == 3) {
            timer.invalidate()
            toggleScan(false)
            self.gatewayListWrapper.hidden = false
            self.homeWrapper.hidden = true
        }
    }
    
    func isBluetoothSwitchedOn() -> Bool{
        
        var stateString: String
        var poweredOn = false
        
        stateString = ""
        
        print("state: ", centralManager.state)
        
        switch(centralManager.state){
            
        case .Unsupported :
            print("BLE unsupported");
            
            stateString = "Bluetooth LE is not supported by this device.";
            
            let modalView = loadModalView("ModalView") as! ModalView
            modalView.delegate = self
            modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseWithoutLoaderAndButton)
            modalHolder.addSubview(modalView)
            modalHolder.hidden = false
            
        case .Unauthorized :
            print("BLE Unauthorized")
            
            stateString = "The app does not have permission to use Bluetooth. Please give permission.";
            
            let modalView = loadModalView("ModalView") as! ModalView
            modalView.delegate = self
            
            if #available(iOS 8.0, *) {
                modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseAndButtonWithoutLoader)
                
                modalView.modalButton.setTitle("Settings", forState: UIControlState.Normal)
            }
            else{
                modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseWithoutLoaderAndButton)
            }
            
            modalHolder.addSubview(modalView)
            modalHolder.hidden = false
            
        case .Unknown :
            print("BLE unsupported");
            
            stateString = "Bluetooth LE is not supported by this device.";
            
            let modalView = loadModalView("ModalView") as! ModalView
            modalView.delegate = self
            modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseWithoutLoaderAndButton)
            modalHolder.addSubview(modalView)
            modalHolder.hidden = false
            
        case .Resetting :
            print("BLE Resetting");
            
        case .PoweredOff :
            print("BLE PoweredOff")
            
            stateString = "Your Bluetooth is not switched on. Please switch it on.";
            
            let modalView = loadModalView("ModalView") as! ModalView
            modalView.delegate = self
            
            if #available(iOS 8.0, *) {
                modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseAndButtonWithoutLoader)
                
                modalView.modalButton.setTitle("Settings", forState: UIControlState.Normal)
            }
            else{
                modalView.initializeModal(stateString, modalType: ModalType.MessageWithCloseWithoutLoaderAndButton)
            }
            
            modalHolder.addSubview(modalView)
            modalHolder.hidden = false
            
        case .PoweredOn :
            print("BLE PoweredOn")
            poweredOn = true

        }
        
        print("stateString: ", stateString)
        
        return poweredOn
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate Functions

extension HomeViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 65.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("GatewaysTableViewCell", forIndexPath: indexPath) as! GatewaysTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("Cell selected at section: ", indexPath.section, " row: ", indexPath.row)
        
        isBluetoothSwitchedOn()
    }
}

// MARK: - CBCentralManagerDelegate Functions

extension HomeViewController{
    
    func centralManagerDidUpdateState(central: CBCentralManager){
        
        switch (central.state)
        {
        case .Unsupported :
            print("BLE unsupported");
            
        case .Unauthorized :
            print("BLE Unauthorized")
            
        case .Unknown :
            print("BLE unsupported");
            
        case .Resetting :
            print("BLE Resetting");
            
        case .PoweredOff :
            print("BLE PoweredOff")
            
        case .PoweredOn :
            print("BLE PoweredOn")
            central.scanForPeripheralsWithServices(nil, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("\(peripheral.name) : \(RSSI) dbm")
    }
    
    func connectPeripheral(peripheral: CBPeripheral,
        options: [String : AnyObject]?) {
            
    }
}

// MARK: - ModalDelegate Functions
extension HomeViewController{
    
    func didClickModalClose(){
        
        modalHolder.hidden = true
        for view in modalHolder.subviews{
            view.removeFromSuperview()
        }
        
    }
    
    func didClickModalButton(){
        
        modalHolder.hidden = true
        for view in modalHolder.subviews{
            view.removeFromSuperview()
        }
        
        
        switch (centralManager.state)
        {
            //have this for temporary
            case .Unauthorized :
                print("BLE Unauthorized")
                
                if #available(iOS 8.0, *) {
                    UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                }
                
            case .PoweredOff :
                print("BLE PoweredOff")
                
                if #available(iOS 8.0, *) {
                    UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                }
                
            default :
                print("BLE Default")
            
        }
        
    }
}
