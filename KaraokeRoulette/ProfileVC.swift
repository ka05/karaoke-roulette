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

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var imagePicker = UIImagePickerController()
    var toggleBoolNavDown = false
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    
    @IBOutlet weak var nav: Navigation!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func toggleNav(sender: UITapGestureRecognizer) {
        println("toggled")
        
        //300
        self.nav.layoutIfNeeded()
        if(toggleBoolNavDown == false){
            self.navHeight.constant = 300
            
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            toggleBoolNavDown = true
        }
        else{
            self.navHeight.constant = 70
            UIView.animateWithDuration(0.6, delay: 0.0, options: nil, animations: { self.nav.layoutIfNeeded() }, completion: nil)
            
            toggleBoolNavDown = false
        }
        
    }
    
    @IBAction func setProfileImage(){
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
//            println("Button capture")
//            
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
//            imagePicker.allowsEditing = false
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
        
        self.presentCamera()
    }
    
    
    func presentCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            print("button capture")
            
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
            cameraUI.mediaTypes = [kUTTypeImage]
            cameraUI.allowsEditing = false
            //cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront
            
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
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
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera)
        {
            // Access the uncropped image from info dictionary
            var imageToSave: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            var imageToSave1: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage //same but with different way
            
            profileImageView.image = imageToSave;
            
            //save to core data
            var dataImage = UIImageJPEGRepresentation(imageToSave, 0.0);
            
            // saving to core data
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            let managedContext = appDelegate.managedObjectContext!
            
            let profileImageData = NSEntityDescription.entityForName("UserInfo", inManagedObjectContext: managedContext)
            
            let profileImageObject = NSManagedObject(entity: profileImageData!, insertIntoManagedObjectContext:managedContext)
            profileImageObject.setValue(dataImage, forKey: "profileImageData")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            
            
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    func savedImageAlert()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func setImgProp(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
//        self.profileImageView.layer.borderWidth = 3
//        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        var profileImageArr = NSArray()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"UserInfo")
        
        //3
        var error: NSError?
        
        var fetchedResults:NSArray = managedContext.executeFetchRequest(fetchRequest, error: &error)!
        
        if(fetchedResults.count > 0){
            var res = fetchedResults[0] as NSManagedObject
            var image = UIImage(CGImage: fetchedResults.valueForKey("profileImageData") as CGImage)
            
            profileImageView.image = image
        }
    
        
        
        
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
