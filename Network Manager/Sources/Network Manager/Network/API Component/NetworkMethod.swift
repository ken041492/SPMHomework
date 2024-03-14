//
//  NetworkMetho.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public enum NetworkRequest: String {
        
        case option = "OPTION"
        
        case get = "GET"
        
        case post = "POST"
        
        case put = "PUT"
        
        case patch = "PATCH"
        
        case delete = "DELETE"
        
        case head = "HEAD"
        
        case trace = "TRACE"
        
        case connect = "CONNECT"
    }
}
