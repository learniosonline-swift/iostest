//
//  PostEndpoint.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation

enum PostEndpoint {
    case getPosts(startIndex: Int, limit: Int)
}

extension PostEndpoint: HTTPEndpoint {
    var path: String {
        switch self {
            case .getPosts:
                return postEndpoint
        }
    }
    
    var queryItems:[URLQueryItem] {
         switch self {
            case .getPosts(let startIndex, let limit):
                return [URLQueryItem(name: postStart, value: "\(startIndex)"),
                URLQueryItem(name: postLimit, value: "\(limit)")]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        switch self {
        case .getPosts:
            return [
                contentType: contentValue
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .getPosts:
            return nil
        }
    }
}
