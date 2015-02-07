//
//  Utils.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation

var MainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

func createDocPath(fileName: String) -> String {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docs = dirPaths[0] as String
    return docs + "/" + fileName
}

func getRandID() -> String {
    return NSUUID().UUIDString
}
