//
//  KaraokeRoulette.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/8/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class UserInfo: NSManagedObject {

    @NSManaged var profileImageData: NSData
    @NSManaged var userID: String
    @NSManaged var userName: String
    @NSManaged var userNumSongsCompleted: NSNumber
    @NSManaged var video: NSSet

}
