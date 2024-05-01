//
//  PostDetailViewController.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 30/04/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyTextView: UITextView!
    
    private var post: Posts!
    private var startDate: Date!
    init?(coder: NSCoder, post: Posts) {
        self.startDate = Date()
        self.post = post
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You shouldn't initialize this controller using init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endDate = Date()
         print("Post detail time(ms) : \(TimerHelper.getTimeTaken(startDate: startDate, endDate: endDate))")
        title = postIdTxt + "\(post.id)"
        postTitleLabel.text = post.title
        postBodyTextView.text = post.body
    }
    
    func setPost(_ post: Posts) {
        self.post = post
    }
}

extension PostDetailViewController {
    static func getController(post: Posts) -> PostDetailViewController {
    
     let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
         let controller = storyBoard.instantiateViewController(identifier: postDetailViewIdentifier, creator: { coder in
            return PostDetailViewController(coder: coder, post: post)
        })  
    
        return controller
    }
}
