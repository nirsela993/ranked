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
    var posts:[Post]?
    var activePost:Post?
    var commentsController :commentsViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.categoryName != nil){
            self.navigationTitle.title = self.categoryName
            
        } else {
            self.categoryName = "home"
        }
        
        self.posts = self.loadPosts(categoyName: self.categoryName!)
    }
    
    func loadPosts(categoyName : String)->[Post]{
        let comments = [
            Comment(author: "omer", text: "Ios is the best i love it so much it makes me cry", dateCreated: Date()),
            Comment(author: "nirssim", text: "lol this is funny i love it", dateCreated: Date()),
            Comment(author: "victor", text: "android sucks", dateCreated: Date())
        ]
        let tempPosts = ["yolo-","i love ","ios is the best - "]
        var returnPosts:[Post] = []
        for postTitle in tempPosts {
            let tempPost:Post = Post(id: "df", category: self.categoryName!, authorNickname: "nirnissim", picture: "pic", title: "", uploadDate: Date(), likes: 12, dislikes: 1, latitube: 12, longtibute: 12, timestamp: 12, comments: comments)
            
            tempPost.title = postTitle+self.categoryName!
            returnPosts.append( tempPost )
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
            postCell.UIpostTitle.text = self.posts?[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentsController?.activePost = self.posts?[indexPath.row]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showCommentsSegue"){
            self.commentsController = (segue.destination as! commentsViewController)
        }
    }
}
