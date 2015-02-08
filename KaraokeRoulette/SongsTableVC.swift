//
//  SongsTableVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import Foundation

class SongsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempItems:[String] = ["song 1", "song2", "song3"]
    
    @IBOutlet weak var nav: UIView!
    
    
    // MARK: - Navigation Control
    
    // Outlets for Navigation
    @IBOutlet weak var navBar: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    var toggleBoolNavDown = false
    
    @IBAction func swipeNavDown(sender: UISwipeGestureRecognizer) {
        println("swipe toggled")
        
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 300
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    @IBAction func swipeNavUp(sender: UISwipeGestureRecognizer) {
        println("swipe toggled")
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 70
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        println("touch toggled")
        
        self.view.bringSubviewToFront(nav)
        
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
            
            toggleBoolNavDown = false
        }
    }
    // END:
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "songsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tempItems.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("songsCell") as UITableViewCell
        
        cell.textLabel?.text = self.tempItems[indexPath.row]
        
        return cell
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        let index = tableView.indexPathForSelectedRow()
//        pizza.pizzaType = pizza.typeList[index.row]
//        if segue.identifier == "toEdit" {
//            let vc = segue.destinationViewController as PizzaTypePriceVC
//            vc.pizzaType = pizza.pizzaType
//            vc.pizzaPrice = pizza.unitPrice()
//        }
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
