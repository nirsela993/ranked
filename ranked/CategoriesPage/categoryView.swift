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
            Comment(author: "omer", text: "Ios is the best i love it so much it makes me cry", dateCreated: "12.12"),
            Comment(author: "nirssim", text: "lol this is funny i love it", dateCreated: "13.12"),
            Comment(author: "victor", text: "android sucks", dateCreated: "14.23")
        ]
        let tempPosts = ["yolo-","i love ","ios is the best - "]
        var returnPosts:[Post] = []
        for postTitle in tempPosts {
            let tempPost:Post = Post(id: "ids", category: self.categoryName!, authorNickname: "nirNissim", picture: "pictureurl", title: postTitle+self.categoryName!, uploadDate: "12.12.12", likes: 20, dislikes: 2, latitude: 10, longitude: 10, comments: comments)
            
            
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
