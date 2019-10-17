//
//  HTTPResponse.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

protocol HTTPResponseDelegate {
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices)
    func httpRequestFinishWithError(message: String, service: HTTPServices)
}
