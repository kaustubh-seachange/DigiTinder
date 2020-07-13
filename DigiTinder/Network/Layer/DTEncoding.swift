//
//  DTEncoding.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

public typealias DTParams = [String: Any]

// MARK: - DTParamEncoder
public protocol DTParamEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: DTParams) throws
}

// MARK: - DTURLEncoder
public struct DTURLEncoder: DTParamEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: DTParams) throws {
        
        guard let url = urlRequest.url else { throw DTNetworkErrors.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
    }
}

// MARK: - DTJSONEncoder
public struct DTJSONEncoder: DTParamEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: DTParams) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters,
                                                        options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }catch {
            throw DTNetworkErrors.encodingFailed
        }
    }
}

// MARK: - DTNetworkErrors
public enum DTNetworkErrors : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

// MARK: - DTEncoding
public enum DTEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    public func encode(urlRequest: inout URLRequest,
                       bodyParams: DTParams?,
                       urlParams: DTParams?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParams else { return }
                try DTURLEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParams else { return }
                try DTJSONEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParams = bodyParams,
                    let urlParams = urlParams else { return }
                try DTURLEncoder().encode(urlRequest: &urlRequest, with: urlParams)
                try DTJSONEncoder().encode(urlRequest: &urlRequest, with: bodyParams)
                
            }
        }catch {
            throw error
        }
    }
}
