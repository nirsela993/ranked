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


class Model{
    static let instance = Model()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:PostModelFirebase? = PostModelFirebase()
    
    private init(){
    }
    
    func addPost(post:Post){
        modelFirebase?.addPost(post: post){(error) in
            //st.addPostToLocalDb(database: self.modelSql?.database)
        }
    }
    
    func getPostsByCategory(id:String, callback:@escaping (Post)->Void){
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
