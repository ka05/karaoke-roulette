//
//  Genre.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import CoreData

class Genre: NSManagedObject {

    @NSManaged var genre: String
    @NSManaged var genreID: NSNumber
    @NSManaged var song: NSSet

}
