//
//  LyricsParser.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import Foundation

class LyricsParser: NSObject {
    let input:String
    var title:String!
    var artist:String!
    var times = [Double]()
    var lines = [String]()
    
    init(input: String) {
        self.input = input
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
    
    // parses the song
    func parseSong() {
        setMeta()
        parseLines()
    }
    
    // sets the song meta data
    func setMeta() {
        self.title = getMatches("\\[title:([a-zA-Z ]+)\\]")[1]
        self.artist = getMatches("\\[artist:([a-zA-Z ]+)\\]")[1]
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
