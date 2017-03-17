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
        }
        
        return cell
    }
}
