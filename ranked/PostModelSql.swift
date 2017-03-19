//
//  PostModelSql.swift
//  ranked
//
//  Created by Nir Sela on 07/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import sqlite3


extension Post{
    static let TABLE = "POSTS"
    static let ID = "ID"
    static let AUTHOR_NICKNAME = "AUTHOR_NICKNAME"
    static let PICTURE = "PICTURE"
    static let CATEGORY = "CATEGORY"
    static let LATITUDE = "LATITUDE"
    static let LONGITUDE = "LONGITUDE"
    static let UPLOAD_DATE = "UPLOAD_DATE"
    static let TITLE = "TITLE"
    static let LAST_UPDATE = "LAST_UPDATE"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( " + ID + " TEXT PRIMARY KEY, "
            + AUTHOR_NICKNAME + " TEXT, "
            + PICTURE + " TEXT, "
            + CATEGORY + " TEXT, "
            + LATITUDE + " DOUBLE, "
            + LONGITUDE + " DOUBLE, "
            + UPLOAD_DATE + " TEXT, "
            + TITLE + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addPostToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Post.TABLE
            + "(" + Post.ID + ","
            + Post.AUTHOR_NICKNAME + ","
            + Post.PICTURE + ","
            + Post.CATEGORY + ","
            + Post.LATITUDE + ","
            + Post.LONGITUDE + ","
            + Post.UPLOAD_DATE + ","
            + Post.TITLE + ","
            + Post.LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let authorNickname = self.authorNickname.cString(using: .utf8)
            let picture = self.picture.cString(using: .utf8)
            let category = self.category.cString(using: .utf8)
            let uploadDate = self.uploadDate.cString(using: .utf8)
            let titel = self.title.cString(using: .utf8);
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, authorNickname,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, picture,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, category, -1, nil);
            sqlite3_bind_double(sqlite3_stmt, 5, self.latitude);
            sqlite3_bind_double(sqlite3_stmt, 6, self.longitude);
            sqlite3_bind_text(sqlite3_stmt, 7, uploadDate, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 8, titel, -1, nil)
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 11, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllPostsFromLocalDb(database:OpaquePointer?)->[Post]{
        var posts : [Post] = []
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " + TABLE + ";",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let postId = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let authorNickname = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let picture = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let category = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let latitude = Double(sqlite3_column_double(sqlite3_stmt,4))
                let longitude = Double(sqlite3_column_double(sqlite3_stmt,5))
                let uploadDate = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let title = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                let lastUpdate = Double(sqlite3_column_double(sqlite3_stmt,8))
                
                let post = Post(id: postId!,category:category!, authorNickname: authorNickname!,
                                picture: picture!, title:title!, uploadDate:uploadDate!, latitude:latitude,
                                longitude:longitude, lastUpdate:Date.fromFirebase(lastUpdate),
                                comments:Comment.getAllCommentsByPostIdFromLocalDb(recPostID: postId!, database: database))
                posts.append(post)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return posts
    }
    
    static func getAllPostsByCategoryFromLocalDb(categoryName:String ,database:OpaquePointer?)->[Post]{
        var posts : [Post] = []
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " + TABLE + " WHERE " + CATEGORY + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            let category = categoryName.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, category,-1,nil);
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                
                let postId = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let authorNickname = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let picture = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let latitude = Double(sqlite3_column_double(sqlite3_stmt,4))
                let longitude = Double(sqlite3_column_double(sqlite3_stmt,5))
                let uploadDate = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let title = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                let lastUpdate = Double(sqlite3_column_double(sqlite3_stmt,8))
                
                let post = Post(id: postId!,category:categoryName, authorNickname: authorNickname!,
                                picture: picture!, title:title!, uploadDate:uploadDate!, latitude:latitude,
                                longitude:longitude, lastUpdate:Date.fromFirebase(lastUpdate),
                                comments: Comment.getAllCommentsByPostIdFromLocalDb(recPostID: postId!, database: database))
                
                posts.append(post)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return posts
    }
    
    static func getPostById(postId:String ,database:OpaquePointer?)->Post?{
        var post : Post?
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " + TABLE + " WHERE " + ID + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            let postIdQuery = postId.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, postIdQuery,-1,nil);
            
            if (sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                
                let authorNickname = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let picture = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let category = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let latitude = Double(sqlite3_column_double(sqlite3_stmt,4))
                let longitude = Double(sqlite3_column_double(sqlite3_stmt,5))
                let uploadDate = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let title = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                let lastUpdate = Double(sqlite3_column_double(sqlite3_stmt,8))
                
                
                
                post = Post(id: postId,category:category!, authorNickname: authorNickname!,
                                picture: picture!, title:title!, uploadDate:uploadDate!, latitude:latitude,
                                longitude:longitude, lastUpdate:Date.fromFirebase(lastUpdate),
                                comments: Comment.getAllCommentsByPostIdFromLocalDb(recPostID: postId ,database: database))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return post
    }
    
}
