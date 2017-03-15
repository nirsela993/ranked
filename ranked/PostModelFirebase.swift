//
//  PostModelFirebase.swift
//  ranked
//
//  Created by Nir Sela on 3/15/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import Firebase

class PostModelFirebase {
    init(){
        FIRApp.configure()
    }
    
    func addStudent(post:Post, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("posts").child(post.id)
        ref.setValue(post.toFirebase())
        ref.setValue(post.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
}
