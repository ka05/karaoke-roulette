//
//  FriendsVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FriendsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var friendsArray: [Friend] = []
    
    // MARK: - Navigation Animations and events
    @IBOutlet weak var nav: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    
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
    
    // MARK: - viewDidLoad-WillAppear
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let req = NSFetchRequest(entityName: "Friend")
        var error:NSError? = nil
        if let fetched = context?.executeFetchRequest(req, error: &error) as? [Friend] {
            friendsArray += fetched
        } else {
            NSLog("Errors: %@", error!.localizedDescription)
        }
//
//        // check validity of query
//        if let results = fetched {
//            friendsArray += results
//            
////            for result in results {
////                friendsArray.append(result)
////                
////                println("blah")
////            }
//        } else {
//            println("Errors: \(error)")
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - collectionView stuff
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendsCell", forIndexPath: indexPath) as CustomFriendsCell
        
        
        
        let friend = friendsArray[indexPath.row]
        NSLog("Rendering cell for friend: %@", friend.profileImage)
        
        cell.friendImage.image = UIImage(named: "profile100")
//        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.width / 2
        cell.friendImage.clipsToBounds = true
        cell.friendImage.layer.borderWidth = 3
        cell.friendImage.layer.borderColor = UIColor.orangeColor().CGColor
        cell.friendName.text = friend.name
        return cell
    }
    
    
    
//    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!)
//    {
//        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendsCell",
//            forIndexPath: indexPath) as UICollectionViewCell
//        
//        let vc = segue.destinationViewController as FriendProfileVC
//        vc.friend = friend
//        
//    }
    
}
