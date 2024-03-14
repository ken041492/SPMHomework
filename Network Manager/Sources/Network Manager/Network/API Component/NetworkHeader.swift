//
//  NetworkHeader.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public enum NetworkHeader: String {
        
        case authorization = "Authorization"
        
        case acceptType = "Accept"
        
        case contentType = "Content-Type"
        
        case acceptEncoding = "Accept-Encoding"
    }
}
