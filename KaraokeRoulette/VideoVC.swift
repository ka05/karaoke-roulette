//
//  VideoVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/8/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {
    
    var video:[Video] = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startPlayingVideo(){
        // get video from documents dir
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString + "/filename"
//        var url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//        
//        moviePlayer = MPMoviePlayerController(contentURL: url)
//        
//        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
//        
//        self.view.addSubview(moviePlayer.view)
//        
//        moviePlayer.fullscreen = true
//        
//        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
