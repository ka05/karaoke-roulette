//
//  CustomFriendsCell.swift
//  KaraokeRoulette
//
//  Created by Apple on 2/7/15.
//  Copyright (c) 2015 Herendeen. All rights reserved.
//

import UIKit

class CustomFriendsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func initWithFriend(name: String, image: UIImage) {
        
        self.friendImage.image = image
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2
        self.friendImage.clipsToBounds = true
        self.friendImage.layer.borderWidth = 3
        self.friendImage.layer.borderColor = UIColor.orangeColor().CGColor
        
        self.friendName.text = name
    }

}
