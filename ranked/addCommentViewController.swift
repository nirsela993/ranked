//
//  addCommentViewController.swift
//  ranked
//
//  Created by macDevMachinVB on 19/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class addCommentViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var authorNicknameField: UITextField!
    @IBOutlet weak var commentTextField: UITextView!
    var activePost:Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.commentTextField.textColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancled(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func addComment(_ sender: Any) {
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        let dateCreated = dateFormatter.string(from: date)
        
        let autherNick = self.authorNicknameField.text
        let commentText = self.commentTextField.text
        
        let com = Comment(postId: (self.activePost?.id)!, author: autherNick!, text: commentText!, dateCreated: dateCreated, lastUpdate: date)
        // TODO: addComment
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "add a public comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
