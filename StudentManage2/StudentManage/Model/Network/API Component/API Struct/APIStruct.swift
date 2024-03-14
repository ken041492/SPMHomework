//
//  APIStruct.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/2.
//

import Foundation

struct authRegisterRequest: Encodable {
    
    var firstname: String
    
    var lastname: String
    
    var email: String
    
    var password: String
}

struct authLoginRequest: Encodable {
    
    var email: String
    
    var password: String
}

struct studentRegisterRequest: Encodable {
    
    var firstName: String
    
    var lastName: String
    
    var email: String
}

struct studentDeleteRequest: Encodable {
    
    var id: Int
    
}

struct studentUpdateRequest: Encodable {
    
    var id: Int
    
    var firstName: String?
    
    var lastName: String?
    
    var email: String?
    
}

struct Empty: Encodable {}

struct JwttokenResponse: Decodable {
    
    var token: String
}

struct StudentResponse: Decodable {
    
    var id: Int
    
    var firstName: String
    
    var lastName: String
    
    var email: String
}


/// 定義User的結構
struct UserResponse: Decodable {
    
    var id: Int
    
    var firstname: String
    
    var lastname: String
    
    var email: String
    
    var password: String
    
    var role: String
    
    var enabled: Bool
    
    var credentialsNonExpired: Bool
    
    var authorities: [AuthorityResponse]
    
    var username: String
    
    var accountNonExpired: Bool
    
    var accountNonLocked: Bool
}

struct AuthorityResponse: Decodable {
    
    var authority: String
}
