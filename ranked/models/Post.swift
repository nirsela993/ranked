//
//  Post.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Post {
    var id:String
    var authorNickname:String
    var picture:String
    var title:String
    var category:String
    var uploadDate:Date
    var likes:NSNumber
    var dislikes:NSNumber
    var latitube:NSNumber
    var longtibute:NSNumber
    var timestamp:NSNumber
    
    init(id:String,category:String, authorNickname:String, picture:String, title:String, uploadDate:Date, likes:NSNumber,dislikes:NSNumber, latitube:NSNumber, longtibute:NSNumber, timestamp:NSNumber) {
        self.id=id
        self.authorNickname=authorNickname
        self.picture=picture
        self.title=title
        self.uploadDate=uploadDate
        self.likes=likes
        self.dislikes=dislikes
        self.latitube=latitube
        self.longtibute=longtibute
        self.timestamp=timestamp
        self.category=category
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = id
        json["authorNickname"] = authorNickname
        json["picture"] = picture
        json["title"] = title
        json["uploadDate"] = uploadDate
        json["likes"] = likes
        json["dislikes"] = dislikes
        json["latitube"] = dislikes
        json["longtibute"] = dislikes
        //        json["timestamp"] = FIRServerValue.timestamp()
        return json
    }
    
}
