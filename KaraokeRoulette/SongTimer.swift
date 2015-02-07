//
//  SongTimer.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation

let countdownNotificationKey = "com.KaraokeRoulette.countdown"
let countdownStopNotificationKey = "com.KaraokeRoulette.countdownStop"
let startTransitionNotificationKey = "com.KaraokeRoulette.startTransition"
let lineChangeNotificationKey = "com.KaraokeRoulette.lineChange"

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
            NSNotificationCenter.defaultCenter().postNotificationName(countdownNotificationKey, object: self)
        } else {
            countdown--
            countMark += countSpace
            NSNotificationCenter.defaultCenter().postNotificationName(countdownNotificationKey, object: self)
            
            // countdown is over
            if countdown == 1 {
                NSNotificationCenter.defaultCenter().postNotificationName(countdownStopNotificationKey, object: self)
            }
        }
    }
    
    // checks the time
    func checkTime() {
        if elapsed > times[index] {
            NSNotificationCenter.defaultCenter().postNotificationName(lineChangeNotificationKey, object: self)
        }
        if elapsed > length { stopTimer() }
    }
    
    // func stopTimer
}