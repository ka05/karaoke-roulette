//
//  Video.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var creationDateTime: NSDate
    @NSManaged var localID: NSNumber
    @NSManaged var songID: NSNumber
    @NSManaged var userID: NSNumber
    @NSManaged var videoID: NSNumber
    @NSManaged var videoName: String
    @NSManaged var user: UserInfo
    @NSManaged var song: Song

}
