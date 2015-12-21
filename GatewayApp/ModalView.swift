//
//  ModalView.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/19/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

enum ModalType {
    case LoaderWithoutButtonAndClose
    case MessageWithCloseWithoutLoaderAndButton
    case MessageWithCloseAndButtonWithoutLoader
}

@objc protocol ModalDelegate {
    optional func didClickModalClose()
    optional func didClickModalButton()
}

class ModalView: UIView {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var modalString: UILabel!
    
    @IBOutlet var buttonWrapper: UIView!
    @IBOutlet var modalButton: UIButton!
    
    @IBOutlet var modalHeight: NSLayoutConstraint!
    @IBOutlet var loaderTop: NSLayoutConstraint!
    @IBOutlet var modalStringHeight: NSLayoutConstraint!
    
    @IBOutlet var modalLeft: NSLayoutConstraint!
    @IBOutlet var modalRight: NSLayoutConstraint!
    @IBOutlet var labelLeft: NSLayoutConstraint!
    @IBOutlet var labelRight: NSLayoutConstraint!
    
    var delegate: ModalDelegate!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func modalAction(sender: AnyObject) {
        delegate.didClickModalButton!()
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        delegate.didClickModalClose!()
    }
    
    func initializeModal(text:String, modalType:ModalType){
        
        modalString.text = text
        modalString.numberOfLines = 0
        
        var labelHeight = heightForLabel(text)
        var remainingHeight: CGFloat
        remainingHeight = 130.0
        
        switch(modalType){
            case ModalType.LoaderWithoutButtonAndClose:
                
                buttonWrapper.hidden = true
                closeButton.hidden = true
                remainingHeight-=50
                break
                
            case ModalType.MessageWithCloseWithoutLoaderAndButton:
                
                loaderTop.constant = -20
                buttonWrapper.hidden = true
                remainingHeight-=50
                remainingHeight-=40
                
                labelHeight+=30
                break
                
            case ModalType.MessageWithCloseAndButtonWithoutLoader:
                
                loaderTop.constant = -20
                remainingHeight-=40
                
                labelHeight+=30
                break
                
            }
        
        modalStringHeight.constant = labelHeight
        modalHeight.constant = labelHeight + remainingHeight
    }

    func heightForLabel(text:String) -> CGFloat{
        
        let labelWidth = UIScreen.mainScreen().bounds.width - modalLeft.constant - modalRight.constant - labelLeft.constant - labelRight.constant
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, labelWidth, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        
        label.sizeToFit()
        print("Returning height for \'", text, "\' label as : ", label.frame.height)
        return label.frame.height
    }
    
    func startAnimatingModalLoader(){
        loader.startAnimating()
    }
    
    func stopAnimatingModalLoader(){
        loader.stopAnimating()
    }

}
