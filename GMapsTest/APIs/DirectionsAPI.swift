//
//  DirectionsAPI.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/9/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import Networking
import SwiftyJSON

public enum navigationMode : String {
    case walking = "walking"
    case transit = "transit"
    case driving = "driving"
    case bicycling = "bicycling"
}

private let baseURL = "https://maps.googleapis.com/"
private let apiKey = "AIzaSyCh2WEn7Ofx6faT6E2vbVlEht7o41Vu0Vw"

class DirectionsAPI: NSObject {
    
    static let shared = DirectionsAPI()
    
    func getDirections(originLat : Double, originLong: Double, destinationLat: Double, destinationLong: Double, navigationMode: String, completion : @escaping (_ route : Route?, _ error : Error?) -> Void) {
        let networking = Networking(baseURL: baseURL)
        networking.get("maps/api/directions/json?origin=\(originLat),\(originLong)&destination=\(destinationLat),\(destinationLong)&key=\(apiKey)&mode=\(navigationMode)") { result in
            switch result {
            case .success(let response):
                let responseData = JSON(response.data)
                let status = responseData["status"].stringValue
                if status == "OK" {
                    let routeData = responseData["routes"].arrayValue.first
                    let route = Route(data: routeData!)
                    completion(route, nil)
                } else {
                    completion(nil, nil)
                }
                
            case .failure(let response):
                // Handle error
                let error = response.error
                completion(nil,error)
            }
        }
    }
    
    
}
