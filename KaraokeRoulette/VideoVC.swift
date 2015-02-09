//
//  VideoVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/8/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoVC: UIViewController {
    
    var video:Video?
    var player:MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startPlayingVideo()
    }

    override func viewWillDisappear(animated: Bool) {
        player.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startPlayingVideo(){
        let path = video?.videoPath
        let url = NSURL.fileURLWithPath(path!)
        player = MPMoviePlayerController(contentURL: url)
        player.view.frame = self.view.bounds
        player.prepareToPlay()
        player.scalingMode = .AspectFill
        self.view.addSubview(player.view)
        self.view.bringSubviewToFront(player.view)
        player.play()
    }
    
    @IBAction func popOut(){
        customNavigateFromSourceViewController(self, toDestinationViewControllerWithIdentifier: "ProfileVC")
        
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
