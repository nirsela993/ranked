//
//  categoryView.swift
//  ranked
//
//  Created by macDevMachinVB on 11/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class categoryView: UIViewController {

    @IBOutlet var categoryNameLabel: UILabel!
    var categoryName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.categoryName != nil){
            categoryNameLabel.text = self.categoryName
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
