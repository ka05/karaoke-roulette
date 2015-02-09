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
import CoreData

class KaraokeVC: UIViewController, AVCaptureFileOutputRecordingDelegate, AVAudioPlayerDelegate {
    
    let session = AVCaptureSession()
    var videoID:String!
    var curFilePath:String!
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
    var shouldSave = false
    
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
    
    @IBAction func popToDetail(){
        if isRecording {
            stopRecording()
        }
        popToDetailController()
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.sessionPreset = AVCaptureSessionPresetMedium
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeLine", name: lineChangeNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "markCountdown", name: countdownNotificationKey, object: nil)
        addLinesToTextView()
        readMP3File()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popToDetailController() {
        let vc = ProfileVC()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: Timing
    
    // starts the countdown process
    func startCountdown() {
        let timer = SongTimer(times: self.times)
        timer.startCountdown(countdown)
        startRecording()
        KaraokeText.text = ""
        KaraokeText.text = "5"
        setCountdownFont()
    }
    
    // mark the countdown time in the view
    func markCountdown() {
        countdown--
        KaraokeText.text = String(countdown)
        setCountdownFont()
        if countdown == 0 {
            // change notifications
            NSNotificationCenter.defaultCenter().postNotificationName(startSongTimingNotificationKey, object: self)
            addLinesToTextView()
            startPlayingAudio()
        }
    }
    
    // changes the highlighted text in the textview
    func changeLine() {
        if let range = getLineChangeRange() {
            KaraokeText.scrollRangeToVisible(range)
            KaraokeText.selectedRange = range
            lineIndex++
        }
    }
    
    // gets the range of a regex match for the line
    func getLineChangeRange() -> NSRange? {
        // filthy filthy hack to prevent errors
        if lineIndex == countElements(lines) {
            return nil
        }
        // turn text into regex
        var lineString = lines[lineIndex]
        if lineString.substringFromIndex(lines[lineIndex].endIndex.predecessor()) == " " {
            lineString = lineString.substringToIndex(lines[lineIndex].endIndex.predecessor())
        }
        lineString = lineString.stringByReplacingOccurrencesOfString(" ", withString: "\\s", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(".", withString: "\\.", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("'", withString: "\\'", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("\n", withString: "\\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        // create regex, get range
        let regex = NSRegularExpression(pattern: lineString, options: nil, error: nil)
        let range = NSMakeRange(0, countElements(KaraokeText.text))
        if let matches = regex?.matchesInString(KaraokeText.text, options: nil, range: range) as? [NSTextCheckingResult] {
            if countElements(matches) > 0 {
                let match = matches.last
                let newRange = match?.range
                return newRange!
            }
        }
        return nil
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
        var toInsert = ""
        for line in self.lines {
            toInsert += line + "\n"
        }
        KaraokeText.text = toInsert
        setKaraokeFont()
        changeLine()
        lineIndex = 0
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
    
    // starts recording to the documents directory
    func startRecording() {
        isRecording = true
        startStopButton.setImage(UIImage(named: "Record"), forState: UIControlState.Normal)
        
        if videoDevice != nil && audioDevice != nil {
            videoID = getRandID()
            curFilePath = createDocPath(videoID) + ".mov"
            curFileURL = NSURL(fileURLWithPath: curFilePath)
            let fileManager = NSFileManager.defaultManager()
            
            // check to see if it exists
            if fileManager.fileExistsAtPath(curFilePath) {
                var err:NSError?
                if !fileManager.removeItemAtPath(curFilePath, error: &err) {
                    println("Error removing file")
                }
            }
            // start recording to file url
            movieOutput?.startRecordingToOutputFileURL(curFileURL, recordingDelegate: self)
        }
    }
    
    // stops the recording
    func stopRecording() {
        // change button and state
        startStopButton.setImage(UIImage(named: "Record_Inactive"), forState: UIControlState.Normal)
        shouldSave = false
        audioPlayer?.stop()
        movieOutput?.stopRecording()
        session.stopRunning()
        popToDetailController()
    }
    
    // MARK: Core Data
    
    // write the video to core data
    func writeToCore() {
        let userID = getUserID() // get the user's ID
        
        // Prep core
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext!
        var toLoad = NSEntityDescription.insertNewObjectForEntityForName("Video", inManagedObjectContext: context) as Video
        
        // prep attributes
        toLoad.creationDateTime = NSDate()
        toLoad.videoID = videoID
        toLoad.songID = song.songID
        toLoad.videoPath = curFilePath
        toLoad.userID = userID
        
        // save
        var error:NSError? = nil
        if !context.save(&error) {
            println("Error: \(error)")
        }
    }
    
    // get the user id
    func getUserID() -> String {
        var userID:String!
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext!
        let req = NSFetchRequest(entityName: "UserInfo")
        var error:NSError? = nil
        let fetched:NSArray = context.executeFetchRequest(req, error: &error)!
        
        if fetched.count > 0 {
            let user = fetched[0] as UserInfo
            userID = user.userID
        }
        return userID
    }
    
    // MARK: MP3 Playback
    
    // reads the mp3 file into the av player
    func readMP3File() {
        setUpAudio()
        var error:NSError?
        println("\(song.fileName)")
        let strLength = countElements(song.fileName)
        let strIndex = strLength - 4
        let name = song.fileName.substringToIndex(advance(song.fileName.startIndex, strIndex))
        println("\(name)")
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "mp3")
        let mp3URL = NSURL(fileURLWithPath: path!)
        
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
    
    func setUpAudio() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.MixWithOthers|AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    func startPlayingAudio() {
        audioPlayer?.play()
    }
    
    // MARK: AVCaptureFileOutputRecordingDelegate
    
    // delegate function, called when recording starts
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        println("Video Recording")
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
        
        // check for recording success
        if recordSuccess {
            
            // delete file if recording was interrupted
            if shouldSave {
                println("File was saved succesfully")
                writeToCore()
            } else {
                // delete the file that was saved
                let fileManager = NSFileManager.defaultManager()
                if fileManager.fileExistsAtPath(curFilePath!) {
                    var err:NSError?
                    if !fileManager.removeItemAtPath(curFilePath!, error: &err) {
                        println("Error removing disrupted file")
                    }
                }
            }
        }
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(stopSongTimingNotificationKey, object: self)
        shouldSave = true
        stopRecording()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
    
    // MARK: Font helpers
    func setCountdownFont() {
        KaraokeText.font = UIFont(name: "Helvetica", size: 52)
        setKaraokeFontAlign()
    }
    
    func setKaraokeFont() {
        KaraokeText.font = UIFont(name: "Helvetica", size: 24)
        setKaraokeFontAlign()
    }
    
    func setKaraokeFontAlign() {
        KaraokeText.textColor = UIColor.whiteColor()
        KaraokeText.textAlignment = NSTextAlignment.Center
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