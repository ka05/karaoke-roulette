//
//  KaraokeVC.swift
//  KaraokeRoulette
//
//  Created by Wyatt McBain on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class KaraokeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let session = AVCaptureSession()
    var preview:AVCaptureVideoPreviewLayer?
    var captureDevice:AVCaptureDevice?
    var audioPlayer:AVAudioPlayer?
    var player:AVPlayer?
    var countdown:Int!
   
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var KaraokeText: UITextView!
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startSong(sender: AnyObject) {
        beginCountdown()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        session.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        
        // Loop through the capture devices on this phone
        for device in devices {
            // make sure device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Check for front camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as NSURL!
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
    }
    
    func requestVideoCapture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
        }
        else {
            println("Camera not available")
        }
    }
    
    func beginSession() {
        var err:NSError? = nil
        session.addInput(AVCaptureDeviceInput(device: captureDevice, error:&err))
        
        if err != nil { NSLog("%@", err!) }
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        self.videoView.layer.addSublayer(preview)
        preview?.frame = self.view.layer.frame
        session.startRunning()
    }
    
    func startRecording() {
        if captureDevice != nil {
            beginSession()
        }
    }
    
    func stopRecording() {
        session.stopRunning()
    }
    
    func destroyScreen() {
        videoView.hidden = true
    }
    
    func compressVideo() {
        
    }
    
    func saveVideo() {
        
    }
    
    func beginCountdown() {
        countdown = 5
        startRecording()
    }
    
    func beginSong() {
        
    }
    
    func playMp3() {
        var songMp3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("2012", ofType: "mp3")!)
        println(songMp3)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var playerItem = AVPlayerItem(URL: songMp3)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
        
        player = AVPlayer(playerItem: playerItem)
        player!.play()
    }
    
    func itemDidFinishPlaying(notification: NSNotification){
        //song is done playing
        
        stopRecording()
        destroyScreen()
        saveVideo()
        
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
