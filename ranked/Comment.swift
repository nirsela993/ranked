//
//  Comment.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var postId:String
    var text:String
    var author:String
    var dateCreated:String
    
    init(postId:String,author:String,text:String,dateCreated:String){
        self.postId = postId
        self.text = text
        self.author = author
        self.dateCreated = dateCreated
    }
    
    init(json:Dictionary<String,Any>){
        self.postId = json["postID"] as! String
        self.text = json["text"] as! String
        self.author = json["author"] as! String
        self.dateCreated = json["dateCreated"] as! String
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["postID"] = self.postId
        json["text"] = self.text
        json["author"] = self.author
        json["dateCreated"] = self.dateCreated
        return json
    }
    
}
