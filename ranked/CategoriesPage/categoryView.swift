//
//  categoryView.swift
//  ranked
//
//  Created by macDevMachinVB on 11/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class categoryView: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var navigationTitle: UINavigationItem!
    var categoryName:String?
    var posts:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.categoryName != nil){
            
            self.navigationTitle.title = self.categoryName
            self.posts = self.loadPosts(categoyName: self.categoryName!)
            
        }
    }
    
    func loadPosts(categoyName : String)->[String]{
        let tempPosts = ["yolo-","i love ","ios is the best - "]
        var returnPosts:[String] = []
        for post in tempPosts {
            returnPosts.append(post+categoryName!)
        }
        return returnPosts
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableCell", for: indexPath)
        
        if let postCell = cell as? postTableViewCell {
            postCell.UIpostTitle.text = self.posts?[indexPath.row]
        }
        
        return cell
    }
}
