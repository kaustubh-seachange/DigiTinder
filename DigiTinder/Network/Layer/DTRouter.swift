//
//  DTRouter.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

// MARK: - Network Completion Block
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

// MARK: - Network Router
protocol DTNetworkRouter: class {
    associatedtype EndPoint: DTEndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

// MARK: - Network Router
class DTRouter<EndPoint: DTEndPointType>: DTNetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            print("URL Request: \(String(describing: request.url))")
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParams,
                                    let bodyEncoding,
                                    let urlParams):
                try self.configureParameters(bodyParams: bodyParams,
                                             bodyEncoding: bodyEncoding,
                                             urlParams: urlParams,
                                             request: &request)
            case .requestParametersAndHeaders(let bodyParams,
                                              let bodyEncoding,
                                              let urlParams,
                                              let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParams: bodyParams,
                                             bodyEncoding: bodyEncoding,
                                             urlParams: urlParams,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParams: DTParams?,
                                         bodyEncoding: DTEncoding,
                                         urlParams: DTParams?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParams: bodyParams, urlParams: urlParams)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: DTHTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
