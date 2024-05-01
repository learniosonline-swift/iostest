//
//  PostListViewController.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import UIKit

class PostListViewController: UIViewController {
    
    private var viewModel: PostsViewModel!
    
    @IBOutlet weak var postsTableView: UITableView!
    let activityView = UIActivityIndicatorView(style: .large)
    var isLoadingList : Bool = false
    
    init?(coder: NSCoder, viewModel: PostsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You shouldn't initialize this controller using init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityView)
        activityView.center = view.center
        title = postsTitle
        fetchPosts()
    }
    
    private func fetchPosts() {
        
        if viewModel.getPostsCount() == batchSize {
            activityView.removeFromSuperview()
            configureActivityView()
        } else if viewModel.getPostsCount() > batchSize {
            configureActivityView()
        }
        activityView.startAnimating()
        
        let startDate = Date()
        viewModel.fetchPosts{ indexPaths, error in
            let endDate = Date()
            print("Post fetch time(ms) : \(TimerHelper.getTimeTaken(startDate: startDate, endDate: endDate))")
            self.isLoadingList = false
            if error != nil {
                self.onFailureCompletion(error: error!)
            } else {
                self.onSuccessCompletion(indexPaths: indexPaths)
            }
        }
    }
    
    private func configureActivityView(){
        postsTableView.tableFooterView = activityView
        activityView.center.x = self.postsTableView.center.x
    }
    
    private func onSuccessCompletion(indexPaths: [IndexPath]){
        DispatchQueue.main.async {
            if indexPaths.count > 0 { 
                let startDate = Date()
                
                self.postsTableView.performBatchUpdates({
                    self.postsTableView.insertRows(at: indexPaths, with: .automatic)}, completion: {_ in 
                        let endDate = Date()
                        self.activityView.stopAnimating()
                        self.postsTableView.tableFooterView  = nil
                        print("Load posts time(ms) : \(TimerHelper.getTimeTaken(startDate: startDate, endDate: endDate))")
                        self.postsTableView.scrollToRow(at: indexPaths.first!, at: .bottom, animated: true)
                    })
            }else {
                self.activityView.stopAnimating()
            }
        }
    }
    
    private func onFailureCompletion(error: RequestError){
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.showError(error: error)
        }
    }
    
    private func showError(error: RequestError) {
        var title = ""
        if error != .noMorePosts {
            title = errorPopupTitle
        }
        let alert = UIAlertController(title: title, message: error.customMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: errorPopupButtonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)  
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPostsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) 
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        let post = viewModel.getPost(atIndex: indexPath.row)
        cell?.textLabel?.text = postIdTxt + "\(post.id)"
        cell?.detailTextLabel?.text = post.title
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList && viewModel.getPostsCount() > 0){
            self.isLoadingList = true
            fetchPosts()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = PostDetailViewController.getController(post: viewModel.getPost(atIndex: indexPath.row))
        navigationController?.pushViewController(controller, animated: true)
    }
}


