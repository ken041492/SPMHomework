//
//  NetworkContentType.swift.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public enum ContentType: String {
        
        case json = "application/json"
        
        case xml = "application/xml"
        
        case x_www_from_urlencoded = "application/x_www_from_urlencoded"
    }
}
