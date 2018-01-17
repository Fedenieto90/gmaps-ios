//
//  Step.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/10/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class Step: NSObject {
    
    var instruction : String
    var duration : String!
    var distance : String!
    var startLocationLat : Double
    var startLocationLong : Double
    var endLocationLat : Double
    var endLocationLong : Double
    var travelMode : String?
    var steps : [Step]?
    var transitDetail : TransitDetail?

    init(instruction : String, duration : String, distance : String, startLocationLat : Double, startLocationLong : Double, endLocationLat : Double, endLocationLong : Double) {
        self.instruction = instruction
        self.duration = duration
        self.distance = distance
        self.startLocationLat = startLocationLat
        self.startLocationLong = startLocationLong
        self.endLocationLat = endLocationLat
        self.endLocationLong = endLocationLong
    }
    
    
    init(data: JSON) {
        self.instruction = data["html_instructions"].stringValue
        self.distance = data["distance"]["text"].stringValue
        self.duration = data["duration"]["text"].stringValue
        self.startLocationLat = data["start_location"]["lat"].doubleValue
        self.startLocationLong = data["start_location"]["lng"].doubleValue
        self.endLocationLat = data["end_location"]["lat"].doubleValue
        self.endLocationLong = data["end_location"]["lng"].doubleValue
        self.travelMode = data["travel_mode"].stringValue
        
        var stepItems = [Step]()
        for step in data["steps"].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
        
        if data["transit_details"].exists() {
            self.transitDetail = TransitDetail(data: data["transit_details"] as JSON)
        }
        
    }
}
