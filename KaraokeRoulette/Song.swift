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

    @NSManaged var artistID: NSNumber
    @NSManaged var genreID: NSNumber
    @NSManaged var length: NSNumber
    @NSManaged var songID: NSNumber
    @NSManaged var songTitle: String
    @NSManaged var artist: Artist
    @NSManaged var genre: Genre
    @NSManaged var video: NSSet

}
