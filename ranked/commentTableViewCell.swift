//
//  commentTableViewCell.swift
//  ranked
//
//  Created by macDevMachinVB on 17/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    var comment:Comment?
    
    @IBOutlet weak var commentMessage: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
