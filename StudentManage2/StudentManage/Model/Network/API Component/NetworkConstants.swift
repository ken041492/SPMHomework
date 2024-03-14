//
//  NetworkConstants.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/2.
//

import Foundation

public struct NetworkServer {
    static let appServer: String = "opendata.cwb.gov.tw/"
    static let localServer: String = "localhost:8080/"
}

public enum ApiPathConstants: String {
    
    case authRegister = "api/v1/auth/register"
    
    case authLogin = "api/v1/auth/authenticate"
    
    case users = "api/v1/auth/users"
    
    case studentRegister = "api/v1/student/register"
    
    case student = "api/v1/student"
    
}

