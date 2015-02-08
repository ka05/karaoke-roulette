//
//  AboutVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    
    // MARK: - Navigation Animations
    @IBOutlet weak var nav: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    var toggleBoolNavDown = false
    
    
    @IBAction func swipeNavDown(sender: UISwipeGestureRecognizer) {
        println("swipe toggled")
        
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 300
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    @IBAction func swipeNavUp(sender: UISwipeGestureRecognizer) {
        println("swipe toggled")
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 70
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        println("touch toggled")
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            
            toggleBoolNavDown = false
        }
        
    }
    // END:
    
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
