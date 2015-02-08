//
//  KaraokeVC.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

// http://www.rockhoppertech.com/blog/swift-avfoundation/#audiofile

import UIKit
import MediaPlayer
import CoreMedia
import MobileCoreServices
import AVFoundation

class KaraokeVC: UIViewController, AVCaptureFileOutputRecordingDelegate, AVAudioPlayerDelegate {
    
    let session = AVCaptureSession()
    var curFilePath:String?
    var curFileURL:NSURL?
    var preview:AVCaptureVideoPreviewLayer?
    var videoDevice:AVCaptureDevice?
    var audioDevice:AVCaptureDevice?
    var isRecording = false
    var audioPlayer:AVAudioPlayer?
    var movieOutput:AVCaptureMovieFileOutput?
    var captureConnection:AVCaptureConnection?
    var player:AVPlayer?
    var song:Song!
    var lines:[String]!
    var times:[Double]!
    var countdown = 5
    var lineIndex = 0
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var KaraokeText: UITextView!
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startSong(sender: AnyObject) {
        if !isRecording {
            startCountdown()
        } else {
            stopRecording()
        }
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        
        // Loop through the capture devices on this phone
        for device in devices {
            // make sure device supports video
            if device.hasMediaType(AVMediaTypeVideo) {
                // Check for front camera
                if device.position == AVCaptureDevicePosition.Front {
                    videoDevice = device as? AVCaptureDevice
                }
            }
        }
        
        // get auido device
        audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        
        // start running the capture session
        if videoDevice != nil && audioDevice != nil {
            beginSession()
        }
    }
    
    // set up
    override func viewWillAppear(animated: Bool) {
        getParserInfo()
        addLinesToTextView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Timing
    
    // starts the countdown process
    func startCountdown() {
        let timer = SongTimer(times: self.times)
        timer.startCountdown(countdown)
        KaraokeText.text = ""
        KaraokeText.font = UIFont(name: "Helvetica", size: 18)
        KaraokeText.text = "5"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "markCountdown", name: countdownNotificationKey, object: nil)
    }
    
    // mark the countdown time in the view
    func markCountdown() {
        countdown--
        KaraokeText.text = String(countdown)
        if countdown == 0 {
            // change notifications
            NSNotificationCenter.defaultCenter().removeObserver(countdownNotificationKey)
            NSNotificationCenter.defaultCenter().postNotificationName(startSongTimingNotificationKey, object: self)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeLine", name: lineChangeNotificationKey, object: nil)
            addLinesToTextView()
        }
    }
    
    // changes the highlighted text in the textview
    func changeLine() {
        KaraokeText.scrollRangeToVisible(getLineChangeRange())
        lineIndex++
    }
    
    // gets the range of a regex match for the line
    func getLineChangeRange() -> NSRange {
        // turn text into regex
        var lineString = lines[lineIndex]
        lineString = lineString.stringByReplacingOccurrencesOfString(" ", withString: "\\s", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(".", withString: "\\.", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("'", withString: "\\'", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("\n", withString: "\\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        // create regex, get range
        let regex = NSRegularExpression(pattern: lineString, options: nil, error: nil)
        let range = NSMakeRange(0, countElements(KaraokeText.text))
        let matches = regex?.matchesInString(KaraokeText.text, options: nil, range: range) as [NSTextCheckingResult]
        let match = matches.last
        let newRange = match?.range
        return newRange!
    }
    
    // MARK: Setup
    
    // Get the song lyrics/times from the parser
    func getParserInfo() {
        let parser = LyricsParser(song: song)
        let parserInfo = parser.getInfo()
        lines = parserInfo.lines
        times = parserInfo.times
    }
    
    // Put line into the text view
    func addLinesToTextView() {
        KaraokeText.text = ""
        KaraokeText.font = UIFont(name: "Helvetica", size: 32)
        var toInsert = ""
        for line in self.lines {
            toInsert += line + "\n"
        }
        KaraokeText.text = toInsert
    }
    
    // MARK: Capture Session
    
    // begins the capture session, but is not recording
    func beginSession() {
        var err:NSError? = nil
        session.addInput(AVCaptureDeviceInput(device: videoDevice, error:&err))
        session.addInput(AVCaptureDeviceInput(device: audioDevice, error: &err))
        session.sessionPreset = AVCaptureSessionPresetLow
        
        if err != nil { NSLog("%@", err!) }
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview?.frame = self.view.bounds
        preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoView.layer.addSublayer(preview)
        
        setUpOutput()
        
        session.startRunning()
    }
    
    // sets up the AVCaptureMovieFileOutput
    func setUpOutput() {
        movieOutput = AVCaptureMovieFileOutput()
        var maxTime:Float64 = 360
        var preferredFramesSec:Int32 = 30
        var maxTotal:CMTime = CMTimeMakeWithSeconds(maxTime, preferredFramesSec)
        
        movieOutput?.minFreeDiskSpaceLimit = 2048*2048
        
        session.addOutput(movieOutput)
    }
    
    // delegate function, called when recording starts
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        println("I am recording")
    }
    
    // delegate function, called when recording completes
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        println("I recorded succesfully")
        var recordSuccess = true
        
        // error checking
        if error != nil {
            let code = error.userInfo?[AVErrorRecordingSuccessfullyFinishedKey] as Bool
            if code {
                recordSuccess = code
            }
        }
        
        if recordSuccess {
            println("File was saved succesffuly")
        }
    }
    
    // starts recording to the documents directory
    func startRecording() {
        if videoDevice != nil && audioDevice != nil {
            curFilePath = createDocPath(getRandID()) + ".mov"
            curFileURL = NSURL(fileURLWithPath: curFilePath!)
            let fileManager = NSFileManager.defaultManager()
            
            // check to see if it exists
            if fileManager.fileExistsAtPath(curFilePath!) {
                var err:NSError?
                if !fileManager.removeItemAtPath(curFilePath!, error: &err) {
                    println("Error removing file")
                }
            }
            // start recording to file url
            movieOutput?.startRecordingToOutputFileURL(curFileURL!, recordingDelegate: self)

            // change button and state
            startStopButton.setTitle("Stop Song", forState: UIControlState.Normal)
            isRecording = true
        }
    }
    
    // stops the recording
    func stopRecording() {
        // change button and state
        startStopButton.setTitle("Start Song", forState: UIControlState.Normal)
        isRecording = false
        movieOutput?.stopRecording()
        session.stopRunning()
    }
    
    func beginCountdown() {
        countdown = 5
        startRecording()
    }
    
    // MARK: MP3 Playback
    
    // reads the mp3 file into the av player
    func readMP3File() {
        var error:NSError?
        let mp3URL = NSBundle.mainBundle().URLForResource(song.fileName, withExtension: "mp3") as NSURL!
        
        // instantiate the avaudioplayer
        self.audioPlayer = AVAudioPlayer(contentsOfURL: mp3URL, error: &error)
        if audioPlayer == nil {
            if let isError = error {
                println("\(isError.localizedDescription)")
            }
        }
        
        // set the delegate
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayer?.volume = 0.6
    }
    
    func startPlayingAudio() {
        audioPlayer?.play()
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(stopSongTimingNotificationKey, object: self)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
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