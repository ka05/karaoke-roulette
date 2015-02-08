//
//  Navigation.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

//http://iphonedev.tv/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6

import UIKit

@IBDesignable class Navigation: UIView{

    var view: UIView!
    
    @IBOutlet weak var sourceVC: UIViewController!
    
    @IBAction func songsLink(sender: AnyObject) {
        println("THIS SHOULD PRINT")
        if let songsTable = sourceVC as? SongsTableVC{
            return
        }
        else{
            
            customNavigateFromSourceViewController(sourceVC, toDestinationViewControllerWithIdentifier: "SongsTableVC")
        }
        
    }
    
    @IBAction func profileLink(sender: AnyObject) {
        if let profile = sourceVC as? ProfileVC{
            return
        }
        else{
            
            customNavigateFromSourceViewController(sourceVC, toDestinationViewControllerWithIdentifier: "ProfileVC")
        }
    }
    
    @IBAction func friendsLink(sender: AnyObject) {
        if let friends = sourceVC as? FriendsVC{
            return
        }
        else{
            
            customNavigateFromSourceViewController(sourceVC, toDestinationViewControllerWithIdentifier: "FriendsVC")
        }
    }
    
    @IBAction func aboutLink(sender: AnyObject) {
        if let about = sourceVC as? AboutVC{
            return
        }
        else{
            
            customNavigateFromSourceViewController(sourceVC, toDestinationViewControllerWithIdentifier: "AboutVC")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Navigation", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
        return view
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
