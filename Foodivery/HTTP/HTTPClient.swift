//
//  HTTPClient.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class HTTPClient {
    
    static let shared = HTTPClient()
    
    private init() {
    }
    
    public func getHTTPHeader() -> HTTPHeaders {
        
        let token = AppDefaults.isLogin ? AppDefaults.apiToken : AppDefaults.guestApiToken
        
            let headers: HTTPHeaders = [
                "platform": "ios",
                "Authorization": "Bearer " + token,
                "app": "0"
            ]
            
            return headers
        
    }
    
    public func get(url: String, completion: @escaping (Bool, Data?, Error?) -> ()){
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, headers: self.getHTTPHeader()).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(_):
                completion(true, response.data, nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        })
    }
    
    public func put(url: String, parameters: Parameters?, completion: @escaping (Bool, Data?, Error?) -> ()){
        Alamofire.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: self.getHTTPHeader()).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(_):
                completion(true, response.data, nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        })
    }
    
    public func delete(url: String, completion: @escaping (Bool, Data?, Error?) -> ()){
        Alamofire.request(url, method: .delete, encoding: URLEncoding.default, headers: self.getHTTPHeader()).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(_):
                completion(true, response.data, nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        })
    }
    
    public func post(url: String, parameter: Parameters?,completion: @escaping (Bool, Data?, Error?) -> ()){
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.getHTTPHeader()).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(_):
                completion(true, response.data, nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        })
    }
}
