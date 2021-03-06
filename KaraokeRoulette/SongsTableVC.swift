//
//  SongsTableVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SongsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempItems:[String] = ["song 1", "song2", "song3"]
    var songsArray: [Song] = [Song]()
    
    @IBOutlet weak var nav: UIView!
    
    
    // MARK: - Navigation Control
    
    // Outlets for Navigation
    @IBOutlet weak var navBar: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var toggleBoolNavDown = false
    
    // swipe down event to pull navigation ui down
    @IBAction func swipeNavDown(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 300
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    // swipe up event to roll navigation ui back up
    @IBAction func swipeNavUp(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 70
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    // touch event to toggle navigation
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.navBar.layoutIfNeeded() }, completion: nil)
            
            toggleBoolNavDown = false
        }
    }
    
    // MARK: - viewDidLoad-WillAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "songsCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let req = NSFetchRequest(entityName: "Song")
        var error:NSError? = nil
        let fetched = context?.executeFetchRequest(req, error: &error) as [NSManagedObject]?
        
        // check validity of query
        if let results = fetched {
            for result in results {
                songsArray.append(result as Song)
            }
        } else {
            println("Errors: \(error)")
        }
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
        return self.songsArray.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.backgroundView = nil;
        tableView.backgroundColor = charcoalColorSpecial
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Configure the cell...
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("songsCell") as UITableViewCell

        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "songsCell")
        
        cell.textLabel?.text = self.songsArray[indexPath.row].songTitle
        cell.detailTextLabel?.text = self.songsArray[indexPath.row].artistName
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let index = tableView.indexPathForSelectedRow()
        let song = songsArray[(index?.row)!]
        
        if segue.identifier == "songsSegue" {
            let vc = segue.destinationViewController as SongsDetailVC
            vc.song = song
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("songsSegue", sender: nil)
    }
    
    // func to handle coloring rows 
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = orangeColorSpecial
        }
        else{
            cell.backgroundColor = blueColorSpecial
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }

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
