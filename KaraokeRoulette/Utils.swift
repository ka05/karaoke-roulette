//
//  Utils.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import UIKit

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

func customNavigateFromSourceViewController(source: UIViewController, toDestinationViewControllerWithIdentifier destinationIdentifier: String) {
    
    // If we crash here, it's because the identifier was not found in the storyboard
    let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(destinationIdentifier) as UIViewController
    
    let navController = source.navigationController
    // If we crash on the next line, it's because the source view controller isn't inside a navigation controller
    navController!.setViewControllers([destinationController], animated: true)
}

func prompt(message: String){
    var alert:UIAlertView = UIAlertView()
    alert.title = "Who are you?"
    alert.message = "Enter your name"
    alert.delegate = self
    alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
    
    alert.addButtonWithTitle("Ok")
    alert.show()
    
}

