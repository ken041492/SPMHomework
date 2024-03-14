//
//  RequestData.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/2.
//


import Foundation

public func requestData<E, D>(method: NetworkRequest,
                              path: ApiPathConstants,
                              parameter: E?,
                              token: String? = nil) async throws -> D where E: Encodable, D: Decodable {
    
    let urlRequest = handleHTTPMethod(method, path, parameter, token)
    
    do {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print("After getting data")
        print(String(data: data, encoding: .utf8)!)
        //        print("==============")
        guard let response = (response as? HTTPURLResponse) else {
            throw NetworkError.invalidResponse
        }
        let statusCode = response.statusCode
        print("catch StatusCode \(statusCode)")
        
        guard (200 ... 299).contains(statusCode) else {
            switch statusCode {
            case 400:
                throw NetworkError.invalidRequest
            case 401:
                throw NetworkError.authorizationError
            case 404:
                throw NetworkError.notFound
            case 500:
                throw NetworkError.internalError
            case 501:
                throw NetworkError.internalError
            case 502:
                throw NetworkError.serverError
            case 503:
                throw NetworkError.serverUnavailable
            default:
                throw NetworkError.invalidResponse
            }
        }
        
        if D.self == NoData.self {
            #if DEBUG
            printNetworkProgress(urlRequest: urlRequest, 
                                 parameters: parameter,
                                 result: "No Data Expected")
            #endif
            // 这里使用一个小技巧，通过强制转换来满足编译器的要求
            return NoData() as! D
        } else {
            do {
                let result = try JSONDecoder().decode(D.self, from: data)
                #if DEBUG
                printNetworkProgress(urlRequest: urlRequest, 
                                     parameters: parameter,
                                     result: result)
                #endif
                
                return result
            } catch {
                throw NetworkError.jsonDecodeFalid(error as! DecodingError)
            }
        }
    } catch {
        print(error.localizedDescription.indices)
        print("=================================")
        throw NetworkError.unknowError(error)
    }
}


public func requestDataEscaping<E, D>(method: NetworkRequest,
                               path: ApiPathConstants,
                               parameter: E?,
                               token: String? = nil,
                               completionHandler: @escaping(Result<D, Error>) -> Void) where E: Encodable, D: Decodable {
    
    let urlRequest = handleHTTPMethod(method, path, parameter, token)
    
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        
        // Check for network error
        if let error = error {
            completionHandler(.failure(NetworkError.unknowError(error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completionHandler(.failure(NetworkError.invalidResponse))
            return
        }
        
        print("catch StatusCode \(httpResponse.statusCode)")

        guard (200...299).contains(httpResponse.statusCode) else {
            // Handling different status codes
            switch httpResponse.statusCode {
            case 400:
                completionHandler(.failure(NetworkError.invalidRequest))
            case 401:
                completionHandler(.failure(NetworkError.authorizationError))
            case 404:
                completionHandler(.failure(NetworkError.notFound))
            case 500:
                completionHandler(.failure(NetworkError.internalError))
            case 501:
                completionHandler(.failure(NetworkError.internalError))
            case 502:
                completionHandler(.failure(NetworkError.serverError))
            case 503:
                completionHandler(.failure(NetworkError.serverUnavailable))
            default:
                completionHandler(.failure(NetworkError.invalidResponse))
            }
            return
        }
        
        if D.self == NoData.self {
            #if DEBUG
            printNetworkProgress(urlRequest: urlRequest,
                                 parameters: parameter,
                                 result: "No Data Expected")
            #endif
            completionHandler(.success(NoData() as! D))
            
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(NetworkError.invalidResponse))
            return
        }
        
        // Attempt to decode the data
        do {
            let decodedData = try JSONDecoder().decode(D.self, from: data)
            completionHandler(.success(decodedData))
        } catch let decodeError as DecodingError {
            completionHandler(.failure(NetworkError.jsonDecodeFalid(decodeError)))
        } catch {
            completionHandler(.failure(NetworkError.unknowError(error)))
        }
    }.resume()
}

private func handleHTTPMethod<E: Encodable>(_ method: NetworkRequest, 
                                            _ path: ApiPathConstants,
                                            _ parameter: E?,
                                            _ jwtToken: String?) -> URLRequest {
    
    let baseURL = Networkbase.http + Networkbase.localServer + path.rawValue
    let url = URL(string: baseURL)
    var urlRequest = URLRequest(url: url!, 
                                cachePolicy: .useProtocolCachePolicy,
                                timeoutInterval: 10)
    let httpType = ContentType.json.rawValue
    
    var headers = [
        NetworkHeader.contentType.rawValue: httpType
    ]
    if let token = jwtToken, !token.isEmpty {
        headers["Authorization"] = "Bearer \(token)"
    }
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.httpMethod = method.rawValue
    
    let dict1 = try? parameter.asDictionary()
    switch method {
    case .post:
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:],
                                                                  options: .prettyPrinted)
    default:
      
        if let parameters = dict1 {
            urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "", parameters: parameters )
        }
        // 將 Encodable 參數轉換為 JSON 數據
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(parameter)
//            urlRequest.httpBody = jsonData
//        } catch {
//            // 處理 JSON 編碼錯誤
//            print("JSON Encoding Error: \(error)")
//        }
    }
    return urlRequest
}

private func requestWithURL(urlString: String, parameters: [String : Any]?) -> URL? {
    
    guard var urlComponents = URLComponents(string: urlString) else { return nil }
    urlComponents.queryItems = []
    parameters?.forEach({(key, value) in
        urlComponents.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        print(urlComponents)
    })
    return urlComponents.url
}

private func printNetworkProgress<E, D>(urlRequest: URLRequest, parameters: E, result: D) where E: Encodable, D: Decodable {
    #if DEBUG
    print("=========================================")
    print("- URL: \(urlRequest.url?.absoluteString ?? "")")
    print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
    print("---------------Request-------------------")
    print(parameters)
    print("---------------Response------------------")
    print(result)
    print("=========================================")
    #endif
}
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
