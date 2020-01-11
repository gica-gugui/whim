//
//  ApiHelper.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Alamofire

public class ApiHelper {
    public class func getURL(_ baseUrl: String, action: String, parameters: [String : String]?) -> URL? {
        var components = URLComponents(string: baseUrl)!
        components.path.append(action)

        var queryItems = [URLQueryItem]()

        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }

            components.queryItems = queryItems
        }

        components.percentEncodedQuery = components.query

        return components.url
    }
    
    public class func getBody<T>(_ model: T) -> Data? where T: Encodable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Date.sharedGeneralDateFormatter())
        encoder.outputFormatting = .prettyPrinted
        
        do {
            return try encoder.encode(model)
        } catch {
            fatalError("Model encoding failed with error \(error.localizedDescription)")
        }
    }
    
    public class func getBody(_ parameters: [String : String]) -> Data? {
        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Json serialization failed with error \(error.localizedDescription)")
        }
        
        return data
    }

    public class func getBody(_ parameters: [String : AnyObject]) -> Data? {
        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Json serialization failed with error \(error.localizedDescription)")
        }
        
        return data
    }

    public class func getBody(_ parameters: [String : Any]) -> Data? {
        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Json serialization failed with error \(error.localizedDescription)")
        }
        
        return data
    }

    public class func getBody(_ parameters: [String]) -> Data? {
        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Json serialization failed with error \(error.localizedDescription)")
        }
        
        return data
    }

    public class func getBody(_ parameters: AnyObject) -> Data? {
        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Json serialization failed with error \(error.localizedDescription)")
        }
        
        return data
    }

    public class func getRequest(_ url: URL, method: HTTPMethod, headers: [String : String]?, body: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body

        return urlRequest
    }
}
