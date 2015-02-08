//
//  Artist.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class Artist: NSManagedObject {

    @NSManaged var artist: String
    @NSManaged var artistID: NSNumber
    @NSManaged var song: NSSet

}
