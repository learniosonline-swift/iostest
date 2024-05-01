//
//  PostService.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation

protocol PostProtocol {
    func getPosts(startIndex: Int) async -> Result<[Posts], RequestError>
}

struct PostService: PostProtocol {
    
    let httpClient: HTTPClientProtocol
    private let batchSize: Int
    init(httpClient: HTTPClientProtocol, batchSize: Int) {
        self.httpClient = httpClient
        self.batchSize = batchSize
    }
}

extension PostService {

    func getPosts(startIndex: Int) async -> Result<[Posts], RequestError> {
        return await httpClient.sendRequest(endpoint: PostEndpoint.getPosts(startIndex: startIndex, limit: batchSize), responseModel: [Posts].self)
    }
}
