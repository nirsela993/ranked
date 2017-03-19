//
//  CommentModel.swift
//  ranked
//
//  Created by Nir Sela on 3/19/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation



class CommentModel{
    static let instance = CommentModel()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:CommentModelFirebase? = CommentModelFirebase()
    
    private init(){
    }
    
    func addComment(comment:Comment){
        modelFirebase?.addComment(comment: comment){(error) in
            //st.addPostToLocalDb(database: self.modelSql?.database)
        }
    }
    
    func getCommentsByPostId(postId:String, callback:@escaping ([Comment])->Void){
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql!.database, table: postId)
        
        // get all updated records from firebase
        modelFirebase?.getCommentsByPostId(postId: postId, lastUpdate: lastUpdateDate, callback: { (comments) in
            //update the local db
            print("got \(comments.count) new records from FB")
            var lastUpdate:Date?
            for comment in comments{
                comment.addCommentToLocalDb(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = comment.lastUpdate
                }else{
                    if lastUpdate!.compare(comment.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = comment.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: postId, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Comment.getAllCommentsByPostIdFromLocalDb(recPostID: postId, database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
}
