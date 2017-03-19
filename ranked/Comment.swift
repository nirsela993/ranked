//
//  Comment.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Comment {
    var postId:String
    var text:String
    var author:String
    var dateCreated:String
    var lastUpdate:Date?
    
    init(postId:String,author:String,text:String,dateCreated:String,lastUpdate:Date){
        self.postId = postId
        self.text = text
        self.author = author
        self.dateCreated = dateCreated
        self.lastUpdate = lastUpdate
    }
    
    init(json:Dictionary<String,Any>){
        self.postId = json["postID"] as! String
        self.text = json["text"] as! String
        self.author = json["author"] as! String
        self.dateCreated = json["dateCreated"] as! String
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["postID"] = self.postId
        json["text"] = self.text
        json["author"] = self.author
        json["dateCreated"] = self.dateCreated
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
    
}
