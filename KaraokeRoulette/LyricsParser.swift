//
//  LyricsParser.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LyricsParser: NSObject {
    let song:Song
    var input:String
    var length:Float
    var times = [Double]()
    var lines = [String]()
    
    init(song: Song) {
        self.song = song
        self.input = song.lyrics
        self.length = song.length as Float
    }
    
    // Gets the info of song, sends it back
    func getInfo() -> (lines: [String], times: [Double], length: Float) {
        parseLines()
        return (lines: self.lines, times: self.times, self.length)
    }
    
    // Performs regular expression grouping
    func getMatches(pattern: String) -> [String] {
        // set up
        let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)
        let range = NSMakeRange(0, countElements(input))
        let matches = regex?.matchesInString(input, options: nil, range: range) as [NSTextCheckingResult]
        
        // Batch groups
        var captures = [String]()
        for match in matches {
            let rCount = match.numberOfRanges
            
            for group in 0..<rCount {
                captures.append((self.input as NSString).substringWithRange(match.rangeAtIndex(group)))
            }
        }
        return captures
    }
    
    // parses the lyric lines
    func parseLines() {
        let lines = getMatches("\\[(\\d{2}:\\d{2}\\.\\d{2})\\]([a-zA-Z' ]+)")
        
        var tempTimes = [NSString]()
        var nextTime = 1
        var nextLine = 2
        
        for index in 1..<lines.count {
            if index == nextTime {
                tempTimes.append(lines[index] as NSString)
                nextTime += 3
            }
            if index == nextLine {
                self.lines.append(lines[index])
                nextLine += 3
            }
        }
        convertTimes(tempTimes)
    }
    
    // gets the times for the changes
    func convertTimes(times: [NSString]) {
        for time in times {
            let secs:NSString = time.substringWithRange(NSMakeRange(3, 5))
            self.times.append(secs.doubleValue)
        }
    }
}
