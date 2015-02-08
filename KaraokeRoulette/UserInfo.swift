//
//  UserInfo.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class UserInfo: NSManagedObject {

    @NSManaged var userName: String
    @NSManaged var userID: String
    @NSManaged var profileImageData: NSData
    @NSManaged var video: NSSet

}
