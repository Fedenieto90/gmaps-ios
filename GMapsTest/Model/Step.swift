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
    var durationText : String
    var durationValue : Double
    var distanceText : String
    var distanceValue : Double
    var startLocationLat : Double
    var startLocationLong : Double
    var endLocationLat : Double
    var endLocationLong : Double
    var maneuver : String
    var travelMode : String?
    var steps : [Step]?
    var transitDetail : TransitDetail?
    var polylinePoints : String?
    
    
    init(data: JSON) {
        self.instruction = data["html_instructions"].stringValue
        self.distanceText = data["distance"]["text"].stringValue
        self.distanceValue = data["distance"]["value"].doubleValue
        self.durationText = data["duration"]["text"].stringValue
        self.durationValue = data["duration"]["value"].doubleValue
        self.startLocationLat = data["start_location"]["lat"].doubleValue
        self.startLocationLong = data["start_location"]["lng"].doubleValue
        self.endLocationLat = data["end_location"]["lat"].doubleValue
        self.endLocationLong = data["end_location"]["lng"].doubleValue
        self.travelMode = data["travel_mode"].stringValue
        self.maneuver = data["maneuver"].stringValue
        var stepItems = [Step]()
        for step in data["steps"].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
        if data["transit_details"].exists() {
            self.transitDetail = TransitDetail(data: data["transit_details"] as JSON)
        }
        self.polylinePoints = data["polyline"]["points"].stringValue
    }
}
