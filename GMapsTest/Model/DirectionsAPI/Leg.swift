//
//  Leg.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let startLocation = "start_location"
    static let endLocation = "end_location"
    static let lat = "lat"
    static let long = "lng"
    static let startAddress = "start_address"
    static let endAddress = "end_address"
    static let distance = "distance"
    static let duration = "duration"
    static let arrivalTime = "arrival_time"
    static let departureTime = "departure_time"
    static let text = "text"
    static let value = "value"
    static let timeZone = "time_zone"
    static let steps = "steps"
}

class Leg: NSObject {
    
    var startAdress : String
    var endAddress : String
    
    var startLocationLat : Double
    var startLocationLong : Double
    
    var endLocationLat : Double
    var endLocationLong : Double
    
    var distanceText : String
    var distanceValue : Double
    
    var durationText : String
    var durationValue : Double
    
    var arrivalTimeText : String
    var arrivalTimeValue : Double
    var arrivalTimeTimezone : Double
    
    var departureTimeText : String
    var departureTimeValue : Double
    var departureTimeTimezone : Double
    
    var steps : [Step]
    
    init(data : JSON) {
        self.startLocationLat = data[Keys.startLocation][Keys.lat].doubleValue
        self.startLocationLong = data[Keys.startLocation][Keys.long].doubleValue
        self.endLocationLat = data[Keys.endLocation][Keys.lat].doubleValue
        self.endLocationLong = data[Keys.endLocation][Keys.long].doubleValue
        self.startAdress = data[Keys.startAddress].stringValue
        self.endAddress = data[Keys.endAddress].stringValue
        self.distanceText = data[Keys.distance][Keys.text].stringValue
        self.distanceValue = data[Keys.distance][Keys.value].doubleValue
        self.durationText = data[Keys.duration][Keys.text].stringValue
        self.durationValue = data[Keys.duration][Keys.value].doubleValue
        self.arrivalTimeText = data[Keys.arrivalTime][Keys.text].stringValue
        self.arrivalTimeValue = data[Keys.arrivalTime][Keys.value].doubleValue
        self.arrivalTimeTimezone = data[Keys.arrivalTime][Keys.timeZone].doubleValue
        self.departureTimeText = data[Keys.departureTime][Keys.text].stringValue
        self.departureTimeValue = data[Keys.departureTime][Keys.value].doubleValue
        self.departureTimeTimezone = data[Keys.departureTime][Keys.timeZone].doubleValue
        
        //Steps
        var stepItems = [Step]()
        for step in data[Keys.steps].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
    }

}
