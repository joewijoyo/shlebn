//
//  PostToDisplay.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/20/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class PostToDisplay {
    var imageURL: String?
    var user: String
    var likes: Int
    var followers: Int
    var caption: String?
    var location: String?
    
    init(user: String, likes: Int, followers: Int) {
        self.imageURL = nil
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = nil
        self.location = nil
    }
    /*
    init(imageURL: String, user: String, likes: Int, followers: Int) {
        self.imageURL = imageURL
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = nil
        self.location = nil
    }
     */
    
    init(imageURL: String, user: String, caption: String, location: String, likes: Int, followers: Int) {
        self.imageURL = imageURL
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = caption
        self.location = location
    }
    
    //in the case that image does not load
    init(user: String, likes: Int, followers: Int,caption: String, location: String) {
        self.imageURL = nil
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = caption
        self.location = location
    }
    //in the case that caption does not load 
    init(imageURL: String, user: String, location: String, likes: Int, followers: Int) {
        self.caption = nil
        self.imageURL = imageURL
        self.user = user
        self.likes = likes
        self.followers = followers
        self.location = location
    }
    //in the case that location does not load 
    init(imageURL: String, user: String, caption: String, likes: Int, followers: Int) {
        self.imageURL = imageURL
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = caption
        self.location = nil
    }
    //in the case that neither location nor caption loads
    init(imageURL: String, user: String, likes: Int, followers: Int) {
        self.imageURL = imageURL
        self.user = user
        self.likes = likes
        self.followers = followers
        self.caption = nil
        self.location = nil
    }
    
}
