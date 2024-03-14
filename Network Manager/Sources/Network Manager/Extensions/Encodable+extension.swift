//
//  Encodable+extension.swift
//  
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String : Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
