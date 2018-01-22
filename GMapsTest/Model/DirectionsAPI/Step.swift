//
//  Step.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/10/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let htmlInstructions = "html_instructions"
    static let distance = "distance"
    static let duration = "duration"
    static let text = "text"
    static let value = "value"
    static let startLocation = "start_location"
    static let latitude = "lat"
    static let longitude = "lng"
    static let endLocation = "end_location"
    static let travelMode = "travel_mode"
    static let maneuver = "maneuver"
    static let steps = "steps"
    static let transitDetails = "transit_details"
    static let polyline = "polyline"
    static let points = "points"
}

public enum TravelMode : String {
    case driving = "DRIVING"
    case walking = "WALKING"
    case bicycling = "BICYCLING"
}

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
    var travelMode : TravelMode?
    var steps : [Step]?
    var transitDetail : TransitDetail?
    var polylinePoints : String
    
    
    init(data: JSON) {
        self.instruction = data[Keys.htmlInstructions].stringValue
        self.distanceText = data[Keys.distance][Keys.text].stringValue
        self.distanceValue = data[Keys.distance][Keys.value].doubleValue
        self.durationText = data[Keys.duration][Keys.text].stringValue
        self.durationValue = data[Keys.duration][Keys.value].doubleValue
        self.startLocationLat = data[Keys.startLocation][Keys.latitude].doubleValue
        self.startLocationLong = data[Keys.startLocation][Keys.longitude].doubleValue
        self.endLocationLat = data[Keys.endLocation][Keys.latitude].doubleValue
        self.endLocationLong = data[Keys.endLocation][Keys.longitude].doubleValue
        let travelMode = data[Keys.travelMode].stringValue
        if travelMode == TravelMode.bicycling.rawValue {
            self.travelMode = .bicycling
        } else if travelMode == TravelMode.driving.rawValue {
            self.travelMode = .driving
        } else if travelMode == TravelMode.walking.rawValue {
            self.travelMode = .walking
        }
        self.maneuver = data[Keys.maneuver].stringValue
        self.polylinePoints = data[Keys.polyline][Keys.points].stringValue
        
        //Steps
        var stepItems = [Step]()
        for step in data[Keys.steps].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
        
        //Transit Details
        if data[Keys.transitDetails].exists() {
            self.transitDetail = TransitDetail(data: data[Keys.transitDetails] as JSON)
        }
    }
}
