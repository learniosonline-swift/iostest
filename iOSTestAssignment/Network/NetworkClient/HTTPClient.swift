//
//  HTTPClient.swift
//  iOSTestAssignment
//
//  Created by Surendra Singh on 29/04/24.
//

import Foundation

struct HTTPClient: HTTPClientProtocol {
    
    func sendRequest<T: Decodable>(
        endpoint: PostEndpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            return validateResponse(responseModel: responseModel, data: data, response: response)
            
        } catch {
            return .failure(.unknown)
        }
        
    } 
    
    private func validateResponse<T: Decodable>(responseModel:T.Type, data: Data, response: HTTPURLResponse) -> Result<T, RequestError> {
        switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
        }
    }
}
