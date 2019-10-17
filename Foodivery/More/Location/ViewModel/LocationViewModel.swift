//
//  LocationViewModel.swift
//  Foodivery
//
//  Created by Admin on 5/24/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

import GoogleMaps
import MapKit
import SwiftyJSON

protocol LocationViewModel {
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    func getDistanceInfo(origin: String, destination: String)
    
}

class LocationViewModelImp: NSObject, LocationViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate?
    
    func getDistanceInfo(origin: String, destination: String){
        
//        let originString = "\(origin.latitude),\(origin.longitude)"
//        let destinationString = "\(destination.latitude),\(destination.longitude)"
        
        let unitSystem = "units=\(UnitSystem.imperial.rawValue)"
        let url = ApiRouter.googleDistanceApiURL(origin: origin, destination: destination, unit: unitSystem)
        
        HTTPClient.shared.get(url: url, completion: {success, responseData, error in
            if success {
                let json = JSON(responseData!)
                let durationText = json["routes"][0]["legs"][0]["duration"]["text"].stringValue
                let durationValue = json["routes"][0]["legs"][0]["duration"]["value"].intValue
                let distanceText = json["routes"][0]["legs"][0]["distance"]["text"].stringValue
                let distanceValue = json["routes"][0]["legs"][0]["distance"]["value"].intValue
                let polyline = json["routes"][0]["overview_polyline"]["points"].stringValue
                let location = Location(durationText: durationText, durationValue: durationValue, distanceText: distanceText, distanceValue: distanceValue, polyline: polyline)
                self.httpResponseHandler?.httpRequestFinishWithSuccess(response: location, service: HTTPServices.googleDistanceApi)
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .googleDistanceApi)
            }
        })
    }
}
