//
//  AboutVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    
    // MARK: - Navigation Control
    
    // Outlets for Navigation
    @IBOutlet weak var nav: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    var toggleBoolNavDown = false
    
    // swipe down event to pull navigation ui down
    @IBAction func swipeNavDown(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 300
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    // swipe up event to roll navigation ui back up
    @IBAction func swipeNavUp(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 70
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    // touch event to toggle navigation
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = false
        }
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
