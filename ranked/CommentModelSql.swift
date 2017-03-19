//
//  CommentModelSql.swift
//  ranked
//
//  Created by Victor Zag on 3/18/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import Foundation
import sqlite3

extension Comment{
    static let TABLE = "COMMENTS"
    static let COMMENTID = "COMMENTID"
    static let POSTID = "POSTID"
    static let TEXT = "TEXT"
    static let AUTHOR = "AUTHOR"
    static let DATE_CREATED = "DATE_CREATED"
    static let LAST_UPDATE = "LAST_UPDATE"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( " + COMMENTID + " TEXT PRIMARY KEY, "
            + POSTID + " TEXT, "
            + TEXT + " TEXT, "
            + AUTHOR + " TEXT, "
            + DATE_CREATED + " TEXT, "
            + LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    func addCommentToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Comment.TABLE
            + "(" + Comment.COMMENTID + ","
            + Comment.POSTID + ","
            + Comment.TEXT + ","
            + Comment.AUTHOR + ","
            + Comment.DATE_CREATED + ","
            + Comment.LAST_UPDATE + ") VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let tempCommId = self.postId + self.dateCreated
            let postID = self.postId.cString(using: .utf8)
            let commentText = self.text.cString(using: .utf8)
            let author = self.author.cString(using: .utf8)
            let dateCreated = self.dateCreated.cString(using: .utf8)
            let commentId = tempCommId.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, commentId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, postID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, commentText,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, author, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 5, dateCreated, -1, nil);

            if (self.lastUpdate == nil){
                self.lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 6, self.lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new comment added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllCommentsByPostIdFromLocalDb(recPostID: String,database:OpaquePointer?)->[Comment]{
        var comments : [Comment] = []
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from " + TABLE + " WHERE " + POSTID + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            // paramet for sql
            let postID = recPostID.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, postID,-1,nil);
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let commandText = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let commentAuthor = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let dateCreated = String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let lastUpdate = Double(sqlite3_column_double(sqlite3_stmt,5))

                
                let comment = Comment(postId: recPostID, author: commentAuthor!, text: commandText!, dateCreated: dateCreated!, lastUpdate:Date.fromFirebase(lastUpdate))
                comments.append(comment)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return comments
    }

}
