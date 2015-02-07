//
//  SongTimer.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation

class SongTimer : NSObject {
    let times:[Double]
    let length:Double
    let countSpace:Double
    var started:Bool
    var firstCount:Bool
    var countdown:Int
    var index:Int
    var countMark:Double
    var start = NSTimeInterval()
    var elapsed = NSTimeInterval()
    var timer:NSTimer!
    
    init(times: [Double], length: Double) {
        self.times = times
        self.length = length
        self.started = false
        self.firstCount = true
        self.countMark = 0.6
        self.countSpace = self.countMark
        self.index = 0
        self.countdown = 5
    }
    
    // called when deinit
    deinit {
        removeSongStartObserver()
    }
    
    // adds the observer for song start
    func addSongStartObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startSongTiming", name: "com.KaraokeRoulette.songStart", object: nil)
    }
    
    // remove the observer for song start
    func removeSongStartObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Starts the timing function
    func startTiming() {
        let sel:Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: sel, userInfo: nil, repeats: true)
        self.start = NSDate.timeIntervalSinceReferenceDate()
    }
    
    // Updates the current time
    func updateTime() {
        var current = NSDate.timeIntervalSinceReferenceDate()
        elapsed = (round((current - start) * 100) / 100)
        if !started {
            performCountdown()
            return
        }
        checkTime()
    }
    
    // Performs the countdown operation
    func performCountdown() {
        if firstCount {
            self.addSongStartObserver()
            NSNotificationCenter.defaultCenter().postNotificationName(countdownNotificationKey, object: self)
        } else {
            countdown--
            countMark += countSpace
            NSNotificationCenter.defaultCenter().postNotificationName(countdownNotificationKey, object: self)
            
            // countdown is over
            if countdown == 0 {
                NSNotificationCenter.defaultCenter().postNotificationName(countdownStopNotificationKey, object: self)
                stopTimer()
            }
        }
    }
    
    // starts the song timing
    func startSongTiming() {
        self.started = true
        startTiming()
    }
    
    // checks the time
    func checkTime() {
        if elapsed > times[index] {
            NSNotificationCenter.defaultCenter().postNotificationName(lineChangeNotificationKey, object: self)
        }
        if elapsed > length { stopTimer() }
    }
    
    // func stopTimer
    func stopTimer() {
        timer.invalidate()
    }
}
