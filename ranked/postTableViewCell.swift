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
    
    @IBOutlet weak var UIpostTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func loadPost(){
        self.UIpostTitle.text = activePost?.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
