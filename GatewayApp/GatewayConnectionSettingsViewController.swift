//
//  GatewayConnectionSettingsViewController.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/21/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit
import DropDown

class GatewayConnectionSettingsViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollHeight: NSLayoutConstraint!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var wifiWrapper: UIView!
    @IBOutlet var getLocalAPButton: UIButton!
    @IBOutlet var SSIDName: UITextField!
    @IBOutlet var SSIDPassword: UILabel!
    @IBOutlet var securityType: UIButton!
    
    @IBOutlet var cellularWrapper: UIView!
    @IBOutlet var APIName: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var APIPassword: UITextField!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var modalHolder: UIView!
    
    var window: UIWindow?
    var activeField: UITextField!
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollHeight.constant = UIScreen.mainScreen().bounds.height
        
        //Segmented Control customization
        segmentedControl.layer.cornerRadius = 0
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.tintColor = UIColor(red: 65.0/255.0, green: 65.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        segmentedControl.layer.borderColor = UIColor.whiteColor().CGColor
        segmentedControl.layer.borderWidth = 1

        //Background view
        let backgroundView = loadViewFromNib("BackgroundView")
        self.backgroundView.addSubview(backgroundView)
        
        //Drop down
        securityType.layer.borderWidth = 1.0
        securityType.layer.borderColor = UIColor.blackColor().CGColor
        
        dropDown.dataSource = [
            "WEP",
            "WPA",
            "WPA2"
        ]
        dropDown.selectRowAtIndex(0)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.securityType.setTitle(item, forState: .Normal)
        }
        
        dropDown.anchorView = securityType
        dropDown.bottomOffset = CGPoint(x: 0, y:securityType.bounds.height)
        
        //keyboard handling
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    @IBAction func cancelAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        DismissKeyboard()
        
        switch sender.selectedSegmentIndex{
        case 0:
            
            wifiWrapper.hidden = false
            cellularWrapper.hidden = true
        case 1:
            
            cellularWrapper.hidden = false
            wifiWrapper.hidden = true
            
        default:
            wifiWrapper.hidden = false
            cellularWrapper.hidden = true
        }
        
    }
    @IBAction func getLocalAPAction(sender: AnyObject) {
        
    }
    
    @IBAction func selectSecurityType(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}

//MARK: - Keyboard Handling Functions

extension GatewayConnectionSettingsViewController{
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        print("Inside keyboardWillShow")
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let kbSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        print("kbSize: ", kbSize)
        print("visible region height: ", aRect.size.height)
        print("activeField frame: ", activeField.frame.origin)
        
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            print("************ scrolling to activeField")
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

//MARK: - Helper Functions

extension GatewayConnectionSettingsViewController{
    
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


//MARK: - UITextFieldDelegate Functions
extension GatewayConnectionSettingsViewController{
    
    func textFieldDidBeginEditing(textField: UITextField){
        print("Inside textFieldDidBeginEditing")
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        print("Inside textFieldDidEndEditing")
        activeField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
