//
//  SongsDetailVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class SongsDetailVC: UIViewController {
    var song:Song!
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songLyricsTextView: UITextView!
    
    
    @IBAction func startRecordingSong(sender: AnyObject) {
        
        let karaokeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("KaraokeVC") as KaraokeVC
        
        karaokeVC.song = self.song
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("karaokeNavigationController") as UINavigationController
        self.navigationController?.pushViewController(karaokeVC, animated: true)
        
        //customNavigateFromSourceViewController(self, toDestinationViewControllerWithIdentifier: "KaraokeVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songTitle
        
        // parse lyrics from parser
        let parser = LyricsParser(song: song)
        let lines = parser.getInfo().lines
        
        // iterate and add to lyrics text view
        var toAdd:String = ""
        for line in lines {
            toAdd += line + "\n"
        }
        songLyricsTextView.text = toAdd
        songLyricsTextView.textColor = UIColor.whiteColor()
        songLyricsTextView.font = UIFont(name: "Helvetica", size: 16)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
