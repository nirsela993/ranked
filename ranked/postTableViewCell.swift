//
//  postTableViewCell.swift
//  ranked
//
//  Created by macDevMachinVB on 15/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class postTableViewCell: UITableViewCell {
    
    var activePost :Post?
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var UIpostTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func loadPost(postToLoad:Post , cellIndex:Int, callback:@escaping ()->Void){

        self.activePost = postToLoad
        self.UIpostTitle.text = self.activePost?.title
        self.postDateLabel.text = self.activePost?.uploadDate
        self.authorLabel.text = self.activePost?.authorNickname
        self.postImage.image = #imageLiteral(resourceName: "loading")
        PostModel.instance.getImage(urlStr: (self.activePost?.picture)!, callback: {(image) in
            self.postImage.image = image
            self.setNeedsLayout()
            self.layoutIfNeeded()
//            callback()
        })
        
        self.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
