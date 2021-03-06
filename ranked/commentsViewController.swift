//
//  commentsViewController.swift
//  ranked
//
//  Created by macDevMachinVB on 16/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class commentsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var activePost:Post?
    var addcommentsController :addCommentViewController?
    var refresher: UIRefreshControl!

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var postTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(commentsViewController.refreshTable), for: UIControlEvents.valueChanged)
        commentsTableView.addSubview(refresher)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPostToView()
        
    }
    func refreshTable(){
        self.loadPostToView()
        self.commentsTableView.reloadData()
        refresher.endRefreshing()
    }
    func loadPostToView(){
        self.postTitle.text = self.activePost?.title ?? "title"
        CommentModel.instance.getCommentsByPostId(postId: (self.activePost?.id)!, callback: {(comments) in
            self.activePost?.comments = comments
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activePost?.comments.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableCell", for: indexPath)
        
        if let commentCell = cell as? commentTableViewCell {
            commentCell.comment = activePost?.comments[indexPath.row]
            commentCell.authorName.text = commentCell.comment?.author
            commentCell.commentMessage.text = commentCell.comment?.text
            commentCell.creationDate.text = commentCell.comment?.dateCreated
            
        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addCommentSegue"){
            self.addcommentsController = (segue.destination as! addCommentViewController)
            self.addcommentsController?.activePost = self.activePost
        }
    }
}
