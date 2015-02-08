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
    let countSpace:Double
    var started:Bool
    var firstCount:Bool
    var countdown:UInt8!
    var index:Int
    var countMark:Double
    var start = NSTimeInterval()
    var elapsed = NSTimeInterval()
    var timer:NSTimer!
    
    init(times: [Double]) {
        self.times = times
        self.started = false
        self.firstCount = true
        self.countMark = 0.6
        self.countSpace = self.countMark
        self.index = 0
    }
    
    // called when deinit
    deinit {
        removeSongStartObserver()
    }
    
    // adds the observer for song start
    func addSongStartObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startSongTiming", name: startSongTimingNotificationKey, object: nil)
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
    
    // starts the countdown
    func startCountdown(countdown: UInt8) {
        self.countdown = countdown
        updateTime()
    }
    
    // Performs the countdown operation
    func performCountdown() {
        if firstCount {
            self.addSongStartObserver()
        } else {
            countdown--
            countMark += countSpace
        }
        NSNotificationCenter.defaultCenter().postNotificationName(countdownNotificationKey, object: self)
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
    }
    
    // func stopTimer
    func stopTimer() {
        timer.invalidate()
    }
}
