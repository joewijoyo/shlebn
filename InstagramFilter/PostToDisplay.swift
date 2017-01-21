//
//  PostToDisplay.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/20/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class PostToDisplay {
    var image: UIImage?
    var user: String
    var likes: Int
    var followers: Int
    
    init(image: UIImage, user: String, likes: Int, followers: Int) {
        self.image = image
        self.user = user
        self.likes = likes
        self.followers = followers
    }
    
    init(user: String, likes: Int, followers: Int) {
        self.image = nil
        self.user = user
        self.likes = likes
        self.followers = followers
    }
}
