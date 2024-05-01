//
//  HTTPEndpoint.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation

protocol HTTPEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension HTTPEndpoint {
    var scheme: String {
        return httpsProtocol
    }

    var host: String {
        return hostName
    }
}
