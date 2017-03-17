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
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPostToView()
        
    }
    func loadPostToView(){
        print(self.activePost?.title ?? "nil")
        self.postTitle.text = self.activePost?.title ?? "title"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
