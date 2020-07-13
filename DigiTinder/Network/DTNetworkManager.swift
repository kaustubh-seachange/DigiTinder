//
//  DTNetworkManager.swift
//  DigiTinder
//
//  Created by Kaustubh on 26/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CoreData

enum DTNetworkResponse:String {
    case requestSuccess
    case requestEmptyData = "Response returned with no data to decode."
    case requestAuthError = "You need to be authenticated first."
    case requestBad = "Bad request"
    case requestOutdated = "The url you requested is outdated."
    case requestfailed = "Network request failed."
    case requestDecodeFailed = "We could not decode the response."
}

enum DTResult<T>{
    case success
    case failure(String)
}

class DTNetworkManager {
    
    private static let entityName = "TinderUser"
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    static let environment : DTNetworkEnv = .devlopment
    let router = DTRouter<DTEndPointAPI>()
    //func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void)
    func getDigiTinderProfile(page: Int, completion: @escaping (_ user: TinderUserResponseModel?,_ error: String?)->()){
        router.request(.getDigiTinderProfile) { data, response, error in
            if error != nil {
                completion(nil, DTNetworkResponse.requestfailed.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, DTNetworkResponse.requestEmptyData.rawValue)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        // MARK: Though this is not default setting.
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(ResponseData.self, from: responseData)
                        if response.results.count > 0  {
                            completion(response.results[0].user, nil)
                        } else  {
                            completion(nil, DTNetworkResponse.requestEmptyData.rawValue)
                        }
                    }catch {
                        print(error)
                        completion(nil, DTNetworkResponse.requestDecodeFailed.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response:HTTPURLResponse) -> DTResult<String>{
        switch response.statusCode {
            case 200...299:
                return .success
            case 401...500:
                return .failure(DTNetworkResponse.requestAuthError.rawValue)
            case 501...599:
                return .failure(DTNetworkResponse.requestBad.rawValue)
            case 600:
                return .failure(DTNetworkResponse.requestOutdated.rawValue)
            default:
                return .failure(DTNetworkResponse.requestfailed.rawValue)
        }
    }
}