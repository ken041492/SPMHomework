//
//  NetwordConstents.swift
//  API
//
//  Created by imac-1682 on 2023/8/15.
//

import Foundation

public struct Networkbase {
    static let http: String = "http://"
    static let https: String = "https://"
    static let appServer: String = "opendata.cwb.gov.tw/"
}

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

public enum NetworkHeader: String {
    
    case authorization = "Authorization"
    
    case acceptType = "Accept"
    
    case contentType = "Content-Type"
    
    case acceptEncoding = "Accept-Encoding"
}

public enum ContentType: String {
    
    case json = "application/json"
    
    case xml = "application/xml"
    
    case x_www_from_urlencoded = "application/x_www_from_urlencoded"
}

enum NetworkError: Error {
    
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

public enum ApiPathConstants: String {
        
    case authRegister = "localhost:8080/api/v1/auth/register"
    
    case authLogin = "localhost:8080/api/v1/auth/authenticate"
    
    case student = "localhost:8080/api/v1/student"
    
    case studentRegister = "localhost:8080/api/v1/student/register"
    
}

