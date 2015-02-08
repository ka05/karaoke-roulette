//
//  ProfileVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import CoreData
import Photos

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    var userVideos: [Video] = [Video]()
    var imagePicker = UIImagePickerController()
    var user: UserInfo!
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNumSongsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Navigation Animations
    
    // Outlets for Navigation
    @IBOutlet weak var nav: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    var toggleBoolNavDown = false
    
    @IBAction func swipeNavDown(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 300
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    @IBAction func swipeNavUp(sender: UISwipeGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        self.navHeight.constant = 70
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
        toggleBoolNavDown = true
    }
    
    // touch event to toggle navigation
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        self.view.bringSubviewToFront(nav)
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            
            toggleBoolNavDown = false
        }
    }
    
    // MARK: - Profile Image Handling
    
    // image tapped - set image from library or camera
    @IBAction func imgTapped(sender: UITapGestureRecognizer) {
       //self.presentCamera()
        chooseCameraOrImg("Choose Image or Take one")
    }
    
    // pick photo from library
    func choosePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true , completion:nil)
        
        }
    }
    
    // shows camera ( front camera ) and handles taking photo
    func presentCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            cameraUI.mediaTypes = [kUTTypeImage]
            cameraUI.allowsEditing = false
            cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.Front
            
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary){
        // Access the uncropped image from info dictionary
        var imageToSave: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        var imageToSave1: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage //same but with different way
        
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
            self.saveImageToCoreData(imageToSave)
            self.profileImageView.image = imageToSave
            
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        else{
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                
                self.saveImageToCoreData(imageToSave)
                
                //UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
                
                }, completionHandler:{(success, error) in
                    self.dismissViewControllerAnimated(true) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.savedImageAlert()
                            self.profileImageView.image = imageToSave
                        }
                    }
            })
        }
    }
    
    // func to handle saving image to core data in UserInfo object
    func saveImageToCoreData(imageToSave: UIImage){
        // prepping image to save
        var fixedImg = fixOrientation(imageToSave)
        var dataImage = UIImagePNGRepresentation(fixedImg);
        
        // saving to core data
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // fetch reqest
        let fetchRequest = NSFetchRequest(entityName:"UserInfo")
        var error: NSError?
        var fetchedResults:NSArray = managedContext.executeFetchRequest(fetchRequest, error: &error)!
        
        // if results in table
        if(fetchedResults.count > 0){
            println("found image")
            var res = fetchedResults[0] as NSManagedObject
            res.setValue(dataImage, forKey: "profileImageData")
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
        else{
            
            let profileImageData = NSEntityDescription.entityForName("UserInfo", inManagedObjectContext: managedContext)
            let profileImageObject = NSManagedObject(entity: profileImageData!, insertIntoManagedObjectContext:managedContext)
            profileImageObject.setValue(dataImage, forKey: "profileImageData")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // alert user that the picture has been saved
    func savedImageAlert()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    // trys to get photo out of storage and set the profile photo if one exists
    func setImgProp(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = UIColor.orangeColor().CGColor 
        
        var profileImageArr = NSArray()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"UserInfo")
        var error: NSError?
        
        var fetchedResults:NSArray = managedContext.executeFetchRequest(fetchRequest, error: &error)!
        
        // if user exists in core data
        if fetchedResults.count > 0 {
            var res = fetchedResults[0] as UserInfo
            if let img = res.profileImageData as NSData?{
                
                // photo exists in coredata
                println("\(res.profileImageData)")
                var image:UIImage = UIImage(data: res.valueForKey("profileImageData") as NSData)!
                image = sFunc_imageFixOrientation(image)
                self.profileImageView.image = image
            }
            else{
                //no photo exists in core data yet
                var img = UIImage(named: "profile100")
                self.profileImageView.image = img
            }
        }
    }
    
    
    // fixes orientation of image after save 
    // http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.drawInRect(rect)
        
        var normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    func sFunc_imageFixOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransformIdentity
        
        if (img.imageOrientation == UIImageOrientation.Down
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, 0, img.size.height);
                transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.UpMirrored
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        var ctx:CGContextRef = CGBitmapContextCreate(nil, UInt(img.size.width), UInt(img.size.height),
            CGImageGetBitsPerComponent(img.CGImage), 0,
            CGImageGetColorSpace(img.CGImage),
            CGImageGetBitmapInfo(img.CGImage));
        CGContextConcatCTM(ctx, transform)
        
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored
            ) {
                
                CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage)
        }
        
        
        // And now we just create a new UIImage from the drawing context
        var cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)
        var imgEnd:UIImage = UIImage(CGImage: cgimg)!
        
        return imgEnd
    }
    
    
    // handles alert message prompting user to take photo or choose one from library
    func chooseCameraOrImg(message: String){
        
        var alert : UIAlertController = UIAlertController(title: "Profile Image", message: "Choose Image or Take one", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { alertAction in
            println("Canceled")
        }))
        alert.addAction(UIAlertAction(title: "Choose Image", style: UIAlertActionStyle.Default, handler: { alertAction in
            println("Choose photo")
            self.choosePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Cancel, handler: { alertAction in
            println("Take photo")
            self.presentCamera()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // sets username label
    func setUserNameLabel(name: String){
        userNameLabel.text = name
    }
    
    // set user number of songs unlocked
    func userNumSongsLabel(name: String){
        userNameLabel.text = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setImgProp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(animated: Bool) {
        setUserInfoInUI()
        loadUserVideos()
    }
    
    // MARK: - loading functions
    
    func setUserInfoInUI(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let req = NSFetchRequest(entityName: "UserInfo")
        var error:NSError? = nil
        let fetched = context?.executeFetchRequest(req, error: &error) as [UserInfo]?
        
        // check validity of query
        if let results = fetched {
            for result in results {
                user = result as UserInfo
            }
        } else {
            println("Errors: \(error)")
        }
        
        userNameLabel.text = user.userName as String
        
        var numSongsCompleted = user.userNumSongsCompleted as Int
        var numSongsCompletedString = String(numSongsCompleted)
        userNumSongsLabel.text = numSongsCompletedString + " Songs Completed"
        
    }
    
    // gets users videos from core data
    func loadUserVideos(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext
        let req = NSFetchRequest(entityName: "Video")
        var error:NSError? = nil
        let fetched = context?.executeFetchRequest(req, error: &error) as [Video]?
        
        // check validity of query
        if let results = fetched {
            for result in results {
                userVideos.append(result as Video)
            }
        } else {
            println("Errors: \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.userVideos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.backgroundView = nil;
        tableView.backgroundColor = charcoalColorSpecial
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Configure the cell...
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("videoCell") as UITableViewCell
        
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "videoCell")
        
        // call getVideo to get song corresponding to video
        var song = getVideoForCell(indexPath)
        
        cell.textLabel?.text = song.songTitle
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let index = tableView.indexPathForSelectedRow()
        let video = userVideos[(index?.row)!] as Video
        
        if segue.identifier == "videoSegue" {
            let vc = segue.destinationViewController as VideoVC
            //vc.video = video
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("videoSegue", sender: nil)
    }
    
    
    func getVideoForCell(indexPath: NSIndexPath) -> Song{
        var song:Song!
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Video")
        let predicate = NSPredicate(format: "songID == %@", self.userVideos[indexPath.row].songID)
        fetchRequest.predicate = predicate
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [Song] {
            song = fetchResults[0] as Song
        }
        return song
    }
    
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
