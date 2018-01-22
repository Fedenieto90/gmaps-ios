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

private struct Keys {
    static let status = "status"
    static let routes = "routes"
}

private enum directionsResponseStatus : String {
    case ok = "OK"
    case notFound = "NOT_FOUND"
    case zeroResults = "ZERO_RESULTS"
    case maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED"
    case invalidRequest = "INVALID_REQUEST"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case unknownError = "UNKNOWN_ERROR"
}

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
    
    
    //MARK : - Directions
    
    func getDirections(originLat : Double, originLong: Double, destinationLat: Double, destinationLong: Double, navigationMode: String, completion : @escaping (_ route : Route?, _ error : Error?) -> Void) {
        let networking = Networking(baseURL: baseURL)
        networking.get("maps/api/directions/json?origin=\(originLat),\(originLong)&destination=\(destinationLat),\(destinationLong)&key=\(apiKey)&mode=\(navigationMode)") { result in
            switch result {
            case .success(let response):
                let responseData = JSON(response.data)
                let status = responseData[Keys.status].stringValue
                if status == directionsResponseStatus.ok.rawValue {
                    let routeData = responseData[Keys.routes].arrayValue.first
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
