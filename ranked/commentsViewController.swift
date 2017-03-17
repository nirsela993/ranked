//
//  commentsViewController.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class commentsViewController: UIViewController {
    
    var activePost:Post?
    
    @IBOutlet weak var postTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        if self.activePost != nil {
//         
//        }
        // Do any additional setup after loading the view.
    }
    func loadPostToView(){
        
//        self.postTitle.text = activePost?.title
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
