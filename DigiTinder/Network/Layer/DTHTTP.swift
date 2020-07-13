//
//  DTHTTP.swift
//  DigiTinder
//
//  Created by Kaustubh on 26/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

// MARK: -
public enum DTHTTPMethods : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public typealias DTHTTPHeaders = [String:String]

public enum DTHTTPTask {
    case request
    
    case requestParameters(bodyParams: DTParams?, bodyEncoding: DTEncoding, urlParams: DTParams?)
    
    case requestParametersAndHeaders(bodyParams: DTParams?,
        bodyEncoding: DTEncoding,
        urlParas: DTParams?,
        additionalHeaders: DTHTTPHeaders?)
}

protocol DTEndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: DTHTTPMethods { get }
    var task: DTHTTPTask { get }
    var headers: DTHTTPHeaders? { get }
}
