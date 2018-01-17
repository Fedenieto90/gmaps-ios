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
}

class DirectionsAPI: NSObject {
    
    static let shared = DirectionsAPI()
    
    func getDirections(navigationMode: String, completion : @escaping (_ points : [String], _ steps : [Step]) -> Void) {
        let networking = Networking(baseURL: "https://maps.googleapis.com/maps/api/directions/json?")
        networking.get("origin=39.5975014,2.6405995&destination=39.6080321,2.6448371&key=AIzaSyCh2WEn7Ofx6faT6E2vbVlEht7o41Vu0Vw&mode=\(navigationMode)") { result in
            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                
                let responseData = JSON(response.data)
                
                let routeData = responseData["routes"].arrayValue.first
                let route = Route(data: routeData!)
                
                print(json)
                let routes = json["routes"] as! [NSDictionary]
                
                let legs = routes.first!["legs"] as! [NSDictionary]
                let steps = legs.first!["steps"] as! [NSDictionary]
                
                var pointsArray = [String]()
                var stepsArray = [Step]()
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"] as! NSDictionary
                    let points = routeOverviewPolyline["points"] as! String
                    pointsArray.append(points)
                }
                
                for step in steps {
                    
                    //Instruction
                    let stepInstruction = step["html_instructions"] as! String
                    let stepDistance = step["distance"] as! NSDictionary
                    let stepDistanceText = stepDistance["text"] as! String
                    let stepDuration = step["duration"] as! NSDictionary
                    let stepDurationText = stepDuration["text"] as! String
                    
                    //Step start location
                    let stepStartLocation = step["start_location"] as! NSDictionary
                    let stepStartLocationLat = stepStartLocation["lat"] as! Double
                    let stepStartLocationLong = stepStartLocation["lng"] as! Double
                    
                    //Step end location
                    let stepEndLocation = step["end_location"] as! NSDictionary
                    let stepEndLocationLat = stepEndLocation["lat"] as! Double
                    let stepEndLocationLong = stepEndLocation["lng"] as! Double
                    
                    let step = Step(instruction: stepInstruction, duration: stepDurationText, distance: stepDistanceText, startLocationLat : stepStartLocationLat, startLocationLong : stepStartLocationLong, endLocationLat : stepEndLocationLat, endLocationLong : stepEndLocationLong)
                    
                    stepsArray.append(step)
                }
                
                completion(pointsArray, stepsArray)
            case .failure(let response):
                // Handle error
                completion([],[])
                print(response)
            }
        }
    }
    
    
}
