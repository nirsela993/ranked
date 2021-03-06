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
    @IBOutlet weak var postsTableView: UITableView!
    var categoryName:String?
    var posts:[Post]?
    var activePost:Post?
    var commentsController :commentsViewController?
    var refresher: UIRefreshControl!
    
    @IBAction func sharePressed(_ sender: Any) {
        let textToShare = "Look at this AMAZING Picture I found !!"
        
        if let myWebsite = NSURL(string: "http://www.rankednet.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = self.view
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(categoryView.refreshTable), for: UIControlEvents.valueChanged)
        postsTableView.addSubview(refresher)
        
        if (self.categoryName != nil){
            self.navigationTitle.title = self.categoryName
            
        } else {
            self.categoryName = "home"
        }
        
        self.loadPosts(categoyName: self.categoryName!)
    }
    /*
     func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     
     
     }
     */
    
    func refreshTable(){
        self.loadPosts(categoyName: self.categoryName!)
        refresher.endRefreshing()
    }
    
    func loadPosts(categoyName : String){
        print("loading posts for " + categoryName!)
        if(self.categoryName == "home"){
            PostModel.instance.getAllPosts(callback: {(postsRecived) in
                self.posts = postsRecived
                self.postsTableView.reloadData()
            })
        } else{
            PostModel.instance.getPostsByCategory(categoryName: categoryName!, callback:{ (posts) in
                self.posts = posts
                print("got posts -> post coutnt = " )
                print((self.posts?.count ?? "got no data"))
                self.postsTableView.reloadData()
            })
        }
        
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
        print("kill me  pls")
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableCell", for: indexPath)
        
        if let postCell = cell as? postTableViewCell {
            //            print("loading ----- ")
            //            print(self.posts?[indexPath.row].title,indexPath.row)
            //
            if(postCell.activePost == nil || postCell.activePost?.id != self.posts?[indexPath.row].id ){
                postCell.loadPost(postToLoad: (self.posts?[indexPath.row])!,cellIndex: indexPath.row,callback: { })
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sending comments to comment view with #comments ->>")
        print(self.posts?[indexPath.row].comments.count ?? "no comments?")
        self.commentsController?.activePost = self.posts?[indexPath.row]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showCommentsSegue"){
            self.commentsController = (segue.destination as! commentsViewController)
        }
    }
    
    
    
}
