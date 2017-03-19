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
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPostToView()
        
    }
    func loadPostToView(){
        self.postTitle.text = self.activePost?.title ?? "title"
        
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
    @IBAction func openAddCommentView(_ sender: UIButton) {
//        self.addCommentView.isHidden = !self.addCommentView.isHidden
//
//        for constraint in self.addCommentView.constraints as [NSLayoutConstraint] {
//            print("------testing constraints--------")
//            print("constraint",constraint.identifier ?? "got NIL")
//            if(constraint.identifier == "newCommentHeight"){
//                print("got constraint")
//                if(self.addCommentView.isHidden){
//                    constraint.constant = 0
//                } else{
//                    constraint.constant = 220
//                }
//            }
//        }
//        self.view.layoutIfNeeded()
    }
}
