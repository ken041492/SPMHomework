//
//  NetworkError.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public enum NetworkError: Error {
        
        case unknowError(Error)
        
        case connectionError
        
        case invalidResponse
        
        case jsonDecodeFalid(Error)
        
        case invalidRequest // 400
        
        case authorizationError // 401
        
        case notFound // 404
        
        case internalError // 500
        
        case serverError // 502
        
        case serverUnavailable // 503
        
    }
}
