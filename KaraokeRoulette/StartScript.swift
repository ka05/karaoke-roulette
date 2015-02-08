//
//  StartScript.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

// https://github.com/jquave/Core-Data-In-Swift-Tutorial/tree/Part2/MyLog

import UIKit
import CoreData

class StartScript: NSObject {
    
    let appDelegate:AppDelegate?
    let context:NSManagedObjectContext?
    
    override init() {
        super.init()
        // get the managedobject context
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
    }
    
    func loadSongs() {
        
        // get the data to load
        if let path = NSBundle.mainBundle().pathForResource("Songs", ofType: "plist") {
            
            // cast to dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                
                // get the songs and iterate
                let songs = dict["Songs"] as NSArray
                for index in 0..<songs.count {
                    
                    // add the song
                    if let song = songs[index] as? Dictionary<String, AnyObject> {
                        var toLoad = NSEntityDescription.insertNewObjectForEntityForName("Song", inManagedObjectContext: context!) as Song
                        toLoad.songID = index
                        toLoad.artistName = song["artistName"] as String
                        toLoad.fileName = song["fileName"] as String
                        toLoad.length = song["length"] as Float
                        toLoad.lyrics = song["lyrics"] as String
                        toLoad.songTitle = song["songTitle"] as String
                        
                        // try and add to core data
                        var error:NSError? = nil
                        if !context!.save(&error) {
                            println("Error: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func getUserInfo() {
        var toLoad = NSEntityDescription.insertNewObjectForEntityForName("UserInfo", inManagedObjectContext: context!) as UserInfo
        toLoad.userName = NSUserName()
        toLoad.userID = NSUUID().UUIDString
        
        // insert into core data
        var error:NSError? = nil
        if !context!.save(&error) {
            println("Error: \(error)")
        }
    }
}
