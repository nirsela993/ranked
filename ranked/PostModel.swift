//
//  Model.swift
//  TestFb
//
//  Created by Eliav Menachi on 14/12/2016.
//  Copyright © 2016 menachi. All rights reserved.
//

import Foundation
import UIKit

let notifyPostListUpdate = "com.menachi.NotifyPostListUpdate"

extension Date {
    
    func toFirebase()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    static func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func fromFirebase(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}


class PostModel{
    static let instance = PostModel()
    static let categoriesNames = ["funny","food","cute","science","gross","sports","ios","FAIL"]
    static let categoriesImages = [#imageLiteral(resourceName: "Funny"),#imageLiteral(resourceName: "food"),#imageLiteral(resourceName: "cute"),#imageLiteral(resourceName: "science"),#imageLiteral(resourceName: "gross") ,#imageLiteral(resourceName: "sports"),#imageLiteral(resourceName: "iphone"),#imageLiteral(resourceName: "wtf")]
    private var timer = Timer()

    
    lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:PostModelFirebase? = PostModelFirebase()
    
    private init(){
    }
    
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func sortPosts(this:Post, that:Post) -> Bool{
        if this.lastUpdate != nil && that.lastUpdate != nil{
            return this.lastUpdate! > that.lastUpdate!
        }
        return false
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 60*10, target: self, selector: #selector(self.removeOldImageFiles), userInfo: nil, repeats: true)
    }
    
    @objc func removeOldImageFiles(){
        var totalPostList = Post.getAllPostsFromLocalDb(database: self.modelSql?.database)
        totalPostList = totalPostList.sorted(by: sortPosts)
        for index in 5...totalPostList.count-1 {
            removeImageFromFile(name: totalPostList[index].picture)
        }
    }
    
    private func removeImageFromFile(name:String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(name)
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }}
    
    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        modelFirebase?.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
        }
        else{
            //2. get the image from Firebase
            modelFirebase?.getImageFromFirebase(url: urlStr, callback:{ (image) in if (image != nil){
                //3. save the image localy
                self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image) })
        }
    }
    
    func addPost(post:Post){
        modelFirebase?.addPost(post: post){(error) in
            //st.addPostToLocalDb(database: self.modelSql?.database)
        }
    }
    
    func getPostsByCategory(categoryName:String, callback:@escaping ([Post])->Void){
        let postsByCategory = Post.getAllPostsByCategoryFromLocalDb(categoryName: categoryName, database: self.modelSql?.database)
        callback(postsByCategory)
    }
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Post.TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllPosts(lastUpdateDate, callback: { (posts) in
            //update the local db
            print("got \(posts.count) new records from FB")
            var lastUpdate:Date?
            for st in posts{
                st.addPostToLocalDb(database: self.modelSql?.database)
                //just s check
                if st.comments.count > 0{
                    st.comments[0].addCommentToLocalDb(database: self.modelSql?.database);
                }
                if lastUpdate == nil{
                    lastUpdate = st.lastUpdate
                }else{
                    if lastUpdate!.compare(st.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = st.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Post.TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Post.getAllPostsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllPostsAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Post.TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllPostsAndObserve(lastUpdateDate, callback: { (posts) in
            //update the local db
            print("got \(posts.count) new records from FB")
            var lastUpdate:Date?
            for post in posts{
                post.addPostToLocalDb(database: self.modelSql?.database)
                //just s check
                if post.comments.count > 0{
                    post.comments[0].addCommentToLocalDb(database: self.modelSql?.database);
                }
                if lastUpdate == nil{
                    lastUpdate = post.lastUpdate
                }else{
                    if lastUpdate!.compare(post.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = post.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Post.TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Post.getAllPostsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyPostListUpdate), object:nil , userInfo:["posts":totalList])
        })
    }
}
