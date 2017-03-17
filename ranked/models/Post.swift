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
    var likes:Int
    var dislikes:Int
    var latitude:Double
    var longitude:Double
    var lastUpdate:Date?
    var comments:[Comment]
    
    init(id:String,category:String, authorNickname:String, picture:String, title:String, uploadDate:String, likes:Int, dislikes:Int, latitude:Double, longitude:Double,comments:[Comment]) {
        self.id = id
        self.authorNickname = authorNickname
        self.picture = picture
        self.title = title
        self.uploadDate = uploadDate
        self.likes = likes
        self.dislikes = dislikes
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.comments = comments
    }
    
    init(json:Dictionary<String,Any>){
        id = json["id"] as! String
        authorNickname = json["authorNickname"] as! String
        picture = json["picture"] as! String
        title = json["title"] as! String
        uploadDate = json["uploadDate"] as! String
        likes = json["likes"] as! Int
        dislikes = json["dislikes"] as! Int
        latitude = json["latitude"] as! Double
        longitude = json["longitude"] as! Double
        category = json["category"] as! String
        
        // LOAD COMMENTS HERE NOT DONE
        comments = []//json["comments"] as! [Comment]
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
        json["likes"] = likes
        json["dislikes"] = dislikes
        json["latitude"] = latitude
        json["longitude"] = longitude
        json["category"] = category
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
    
}
