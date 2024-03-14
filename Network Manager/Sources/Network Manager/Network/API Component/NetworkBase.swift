//
//  NetworkBase.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public enum Networkbase: String {
        
        case http = "http://"
        
        case https = "https://"
        
        case appServer = "opendata.cwb.gov.tw/"
        
        case localServer = "localhost:8080/"
    }
}
