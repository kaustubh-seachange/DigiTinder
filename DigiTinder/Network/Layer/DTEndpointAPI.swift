//
//  DTEndpointAPI.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

enum DTNetworkEnv {
    case devlopment
    case preprod
    case production
}

public enum DTEndPointAPI {
    case getDigiTinderProfile
    case getUserImages(userId: Int)
}

extension DTEndPointAPI : DTEndPointType {
    var environmentBaseURL : String {
        switch DTNetworkManager.environment {
            // MARK: - SWIFT has "No Implicit Fallthrough", no break statement required.
            case .production:
                return "https://production.workmetrik.aws.com/api"
            case .preprod:
                return "https://randomuser.me/api"
            case .devlopment:
                return "https://randomuser.me/api"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    // https://randomuser.me/api/?results=50
    
    var path: String {
        switch self {
        case .getUserImages(let userId):
            return "/0.4/\(userId)"
        case .getDigiTinderProfile:
            return "/"
        }
    }
    
    var httpMethod: DTHTTPMethods {
        return .get
    }
    
    var task: DTHTTPTask {
        switch self {
        case .getDigiTinderProfile:
            return .requestParameters(bodyParams: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParams: ["results":"50"]) // parameters can be empty
        default:
            return .request
        }
    }
    
    var headers: DTHTTPHeaders? {
        return nil
    }
}
