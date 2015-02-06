//
//  ProfileVC.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/6/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBAction func setProfileImage(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
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
    
    
    func setImgProp(){
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
        self.profileImg.clipsToBounds = true
        self.profileImg.layer.borderWidth = 3
        self.profileImg.layer.borderColor = UIColor.whiteColor().CGColor
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
