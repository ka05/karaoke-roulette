//
//  StartScript.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

// https://github.com/jquave/Core-Data-In-Swift-Tutorial/tree/Part2/MyLog

import UIKit
import CoreData

class StartScript: NSObject {
   
    func loadInMp3AndUserInfo() {

        // saving to core data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var managedContext = appDelegate.managedObjectContext?

        if let moc = managedContext {
            Song.createInManagedObjectContext(moc,
                artistName: "Guns n' Roses",
                fileName: "Sweet_Child_O'Mine-Guns_N'_Roses.mp3",
                length: 359.68,
                lyrics: "[ti:Sweet Child O' Mine] [ar:Guns N' Roses] [00:45.64]She's got a smile that it seems to me [00:48.38]Reminds me of childhood memories [00:53.29]Where everything [00:54.70]Was as fresh as the bright blue sky [01:00.70]Now and then when I see her face [01:04.48]She takes me away to that special place [01:07.56]And if I stared too long [01:10.16]I'd probably break down and cry [01:15.16]Oh, Sweet child o' mine [01:23.12]Oh oh oh oh, Sweet love of mine [01:26.12] [01:46.00]She's got eyes of the bluest skies [01:50.85]As if they thought of rain [01:54.65]I hate to look into those eyes [01:57.72]And see an ounce of pain [02:01.65]Her hair reminds me of a warm safe place [02:06.24]Where as a child I'd hide [02:09.13]And pray for the thunder [02:12.04]And the rain [02:12.90]To quietly pass me by [02:16.90]Oh, Sweet child o' mine [02:24.11]Oh oh oh oh , Sweet love of mine [02:27.11] [03:03.35]Oh oh oh, Sweet child o' mine [03:10.07]Oh oh oh, Sweet love of mine [03:18.07]Oh oh oh oh, Sweet child o' mine [03:27.07]oh Sweet love of mine [03:30.07] [04:38.06]Where do we go [04:39.94]Where do we go now [04:41.89]Where do we go [04:45.92]Where do we go [04:50.69]Where do we go now [04:53.55]Where do we go [04:57.41]Where do we go now [05:03.41]Where do we go now [05:07.41]Where do we go [05:10.41]Where do we go now [05:15.41]Where do we go [05:19.41]Where do we go now [05:23.41]Where do we go [05:27.41]Where do we go now [05:29.41]now now now now now now now [05:32.80]Sweet child [05:34.41]Sweet child o' mine",
                songID: 1,
                songTitle: "Sweet Child o' Mine")
        }
    }
}
