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
    
    lazy var storageRef = FIRStorage.storage().reference(forURL: "gs://firstfirebase-ae1be.appspot.com/")
    
    func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            filesRef.put(data, metadata: metaData) {
                metadata, error in if (error != nil) {
                    callback(nil)
                }
                else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 100000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }
            else{
                callback(nil)
            }
        })
    }
    
    func addPost(post:Post, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("posts").child(post.id)
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
