//
//  Comment.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var text:String
    var author:String
    var dateCreated:String
    
    init(author:String,text:String,dateCreated:String){
        self.text = text
        self.author = author
        self.dateCreated = dateCreated
    }
    
}
