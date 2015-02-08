//
//  Song.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class Song: NSManagedObject {

    @NSManaged var artistName: String
    @NSManaged var artistImageFileName: String
    @NSManaged var length: NSNumber
    @NSManaged var lyrics: String
    @NSManaged var songID: NSNumber
    @NSManaged var songTitle: String
    @NSManaged var fileName: String
    @NSManaged var video: NSSet

    class func createInManagedObjectContext(moc: NSManagedObjectContext, artistName: String, fileName: String, length: Float, lyrics: String, songID: NSNumber, songTitle: String) -> Song {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Song", inManagedObjectContext: moc) as Song
        newItem.artistName = artistName
        newItem.fileName = fileName
        newItem.length = length
        newItem.lyrics = lyrics
        newItem.songID = songID
        newItem.songTitle = songTitle
        
        return newItem
    }
}
