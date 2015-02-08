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

// Code that handles first runtime of app
class StartScript: NSObject {
    
    // func to handle loading in the songs from a plist
    func loadSongs() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
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
                        toLoad.artistImageFileName = song["artistImageFileName"] as String
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
    
    // gets user info and adds to core data
    func getUserInfo() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        var toLoad = NSEntityDescription.insertNewObjectForEntityForName("UserInfo", inManagedObjectContext: context!) as UserInfo
        toLoad.userName = NSUserName()
        toLoad.userID = NSUUID().UUIDString
        toLoad.userNumSongsCompleted = 0
        
        
        // insert into core data
        var error:NSError? = nil
        if !context!.save(&error) {
            println("Error: \(error)")
        }
    }
    
    
    // loads dummy data for friend from a plist. ( will further implement if we have time )
    func loadFriends(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        // get the data to load
        if let path = NSBundle.mainBundle().pathForResource("Friends", ofType: "plist") {
            
            // cast to dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                
                // get the songs and iterate
                let friends = dict["Friends"] as NSArray
                for index in 0..<friends.count {
                    
                    // add the song
                    if let friend = friends[index] as? Dictionary<String, AnyObject> {
                        var toLoad = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context!) as Friend
                        toLoad.name = friend["name"] as String
                        toLoad.profileImage = friend["profileImage"] as String
                        toLoad.numSongsCompleted = friend["numSongsCompleted"] as NSNumber
                        
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
}
