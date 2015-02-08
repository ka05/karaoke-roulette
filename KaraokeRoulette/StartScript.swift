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
    
    func loadSongs() {
        // get the managedobject context
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
                        toLoad.fileName = song["fileName"] as String
                        toLoad.length = song["length"] as Float
                        toLoad.lyrics = song["lyrics"] as String
                        toLoad.songTitle = song["songTitle"] as String
                        
                        // try and add to core data
                        var error:NSError? = nil
                        if !context!.save(&error) {
                            println("Error: \(error)")
                        }
                        println("\(toLoad) saved.")
                    }
                }
                
                // check to see if they have been saved properly
                let req = NSFetchRequest(entityName: "Song")
                var error:NSError? = nil
                let fetched = context?.executeFetchRequest(req, error: &error) as [NSManagedObject]?
                
                // check validity of query
                if let results = fetched {
                    for result in results {
                        let song = result as? Song
                        println("Id: \(song?.songID), Name: \(song?.songTitle)")
                    }
                } else {
                    println("Errors: \(error)")
                }
            }
        }
    }
    
    func getUserInfo() {
        
    }
}
