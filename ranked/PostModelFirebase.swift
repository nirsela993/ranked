//
//  PostModelFirebase.swift
//  ranked
//
//  Created by Nir Sela on 3/15/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PostModelFirebase {
    init(){
        FIRApp.configure()
    }
    
    func addPost(post:Post, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("posts").child(post.id)
        ref.setValue(post.toFirebase())
        ref.setValue(post.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    func getAllPosts(_ lastUpdate:Date? , callback:@escaping ([Post])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var posts = [Post]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let post = Post(json: json)
                        posts.append(post)
                    }
                }
            }
            callback(posts)
        }
        
        let ref = FIRDatabase.database().reference().child("posts")
        if (lastUpdate != nil){
            print("q starting at:\(lastUpdate!) \(lastUpdate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    func getAllPostsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Post])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var posts = [Post]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let post = Post(json: json)
                        posts.append(post)
                    }
                }
            }
            callback(posts)
        }
        
        let ref = FIRDatabase.database().reference().child("posts")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(FIRDataEventType.value, with: handler)
        }else{
            ref.observe(FIRDataEventType.value, with: handler)
        }
    }
}
