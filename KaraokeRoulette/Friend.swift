//
//  Friend.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/8/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class Friend: NSManagedObject {

    @NSManaged var profileImage: String
    @NSManaged var name: String
    @NSManaged var numSongsCompleted: NSNumber

}
