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
    case requestfailed = "The Internet connection appears to be offline."
    case requestDecodeFailed = "We could not decode the response."
}

enum DTResult<T>{
    case success
    case failure(String)
}

class DTNetworkManager {
    private let persistentContainer: NSPersistentContainer
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    static let environment : DTNetworkEnv = .devlopment
    let router = DTRouter<DTEndPointAPI>()
    
    func readStaticData(named: String) -> Data? {
        do {
            if let bundleUrl = Bundle.main.url(forResource: named, withExtension: "json"),
                let jsonData = try String(contentsOf: bundleUrl).data(using: .utf8) {
                return jsonData
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    public func parseData(json: Data) -> [User]? {
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.persistentContainer.viewContext

            let data = try decoder.decode(ResponseData.self, from: json)
            if data.users.count > 0 {
                return data.users
            } else  {
                print("No Success")
                return nil
            }
        } catch {
            print("decode error")
        }
        return nil
    }
    
    func getDigiTinderProfile(page: Int,
                              completion: @escaping (_ results: [User]?,_ error: String?)->())
    {
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
                        decoder.userInfo[CodingUserInfoKey.context!] = self.persistentContainer.viewContext
                        let parsed = try decoder.decode(ResponseData.self, from: responseData)
                        if parsed.users.count > 0  {
                            completion(parsed.users, nil)
                        } else  {
                            completion(nil, DTNetworkResponse.requestEmptyData.rawValue)
                        }
                    }catch {
                        print("{\(#function):\(#line)} :) \(error.localizedDescription)")
                        completion(nil, DTNetworkResponse.requestDecodeFailed.rawValue)
                    }
                case .failure( _):
                    completion(nil, DTNetworkResponse.requestfailed.rawValue)
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
