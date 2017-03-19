//
//  CommentModelFirebase.swift
//  ranked
//
//  Created by Nir Sela on 3/15/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import Firebase

class CommentModelFirebase {
    
    func addComment(comment:Comment, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("posts").child(comment.postId).child("comments").childByAutoId()
        ref.setValue(comment.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    func getCommentsByPostId(postId:String, lastUpdate:Date? , callback:@escaping ([Comment])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var comments = [Comment]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let comment = Comment(json: json)
                        comments.append(comment)
                    }
                }
            }
            callback(comments)
        }
        
        let ref = FIRDatabase.database().reference().child("posts").child(postId).child("comments")
        if (lastUpdate != nil){
            print("q starting at:\(lastUpdate!) \(lastUpdate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
}
