//
//  File.swift
//  InstagramFilter
//
//  Created by shelby chen on 3/30/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class picNode {
    
    var userName: String!
    var image: String!
    var likes: Int!
    var followers: Int!
    
    init(userName: String!, image: String!, likes: Int!, followers: Int!){
        self.userName = userName
        self.image = image
        self.likes = likes
        self.followers = followers
    }
}
