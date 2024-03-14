//
//  RequestData.swift
//
//
//  Created by imac-3373 on 2024/3/11.
//

import Foundation

extension NetworkManager {
    
    public static func requestData<E, D>(method: NetworkRequest,
                                         http: Networkbase,
                                         server: String,
                                         path: String,
                                         parameter: E?,
                                         token: String? = nil,
                                         completionHandler: @escaping(Result<D, Error>) -> Void) where E: Encodable, D: Decodable {
        
        let urlRequest = handleHTTPMethod(method, http, server, path, parameter, token)
        
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
    
    public static func handleHTTPMethod<E: Encodable>(_ method: NetworkRequest,
                                                       _ http: Networkbase,
                                                       _ server: String,
                                                       _ path: String,
                                                       _ parameter: E?,
                                                       _ jwtToken: String?) -> URLRequest {
        
        let baseURL = http.rawValue + server + path
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
    
    
    public static func requestWithURL(urlString: String, parameters: [String : Any]?) -> URL? {
        
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        urlComponents.queryItems = []
        parameters?.forEach({(key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
            print(urlComponents)
        })
        return urlComponents.url
    }

    public static func printNetworkProgress<E, D>(urlRequest: URLRequest, parameters: E, result: D) where E: Encodable, D: Decodable {
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
}

public struct NoData: Decodable {}
