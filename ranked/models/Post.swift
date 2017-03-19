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
    var uploadDate:String
    var latitude:Double
    var longitude:Double
    var lastUpdate:Date?
    var comments:[Comment]
    
    init(id:String,category:String, authorNickname:String, picture:String, title:String, uploadDate:String, latitude:Double, longitude:Double,lastUpdate:Date?,comments:[Comment]) {
        self.id = id
        self.authorNickname = authorNickname
        self.picture = picture
        self.title = title
        self.uploadDate = uploadDate
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.lastUpdate = lastUpdate
        self.comments = comments
    }
    
    init(json:Dictionary<String,Any>){
        id = json["id"] as! String
        authorNickname = json["authorNickname"] as! String
        picture = json["picture"] as! String
        title = json["title"] as! String
        uploadDate = json["uploadDate"] as! String
        latitude = json["latitude"] as! Double
        longitude = json["longitude"] as! Double
        category = json["category"] as! String
        comments = []
        if (json["comments"] != nil){
            let commentArr = json["comments"] as! NSDictionary
            for comment in commentArr {
                comments.append(Comment(json: comment.value as! Dictionary<String, Any>))
            }
        }
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = id
        json["authorNickname"] = authorNickname
        json["picture"] = picture
        json["title"] = title
        json["uploadDate"] = uploadDate
        json["latitude"] = latitude
        json["longitude"] = longitude
        json["category"] = category
        json["lastUpdate"] = FIRServerValue.timestamp()
        var commentsArr : NSArray = []
        for comment in comments {
            commentsArr = commentsArr.adding(comment.toFirebase()) as NSArray
        }
        json["comments"] = commentsArr
        return json
    }
    
}
