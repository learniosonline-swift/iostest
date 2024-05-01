//
//  PostsViewModel.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation
import UIKit

class PostsViewModel {
    let service: PostProtocol
    private var posts: [Posts] = []
   
    init(service: PostProtocol) {
        self.service = service
    }
    
    func fetchPosts(completionHandler:@escaping(([IndexPath], RequestError?)->Void)) {
        Task(priority: .background) {
            let result = await service.getPosts(startIndex: posts.count)
                switch result {
                    case .success(let posts):
                        let postCount = posts.count
                        self.posts.append(contentsOf: posts)
                        completionHandler(self.getIndexPathsToLoad(currentIndex: self.posts.count - postCount, batchSize: postCount), nil)
                    case .failure(let error):
                        completionHandler([], error)
            }
        }
    }
    
    private func getIndexPathsToLoad(currentIndex:Int, batchSize:Int) -> [IndexPath] {
        if currentIndex >= posts.count - 1 {
            return []
        }
        var indexes: [IndexPath] = []
        for index:Int in currentIndex...posts.count-1 {
            indexes.append(IndexPath(row: index, section: 0))
        }
        return indexes
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    func getPost(atIndex: Int) -> Posts {
        return posts[atIndex]
    }
}
