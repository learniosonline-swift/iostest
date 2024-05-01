//
//  HTTPClientProtocol.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation

protocol HTTPClientProtocol {
    func sendRequest<T: Decodable>(endpoint: PostEndpoint, responseModel: T.Type) async -> Result<T, RequestError>
}
