//
//  Leg.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        self.startLocationLat = data["start_location"]["lat"].doubleValue
        self.startLocationLong = data["start_location"]["lng"].doubleValue
        self.endLocationLat = data["end_location"]["lat"].doubleValue
        self.endLocationLong = data["end_location"]["lng"].doubleValue
        self.startAdress = data["start_address"].stringValue
        self.endAddress = data["end_address"].stringValue
        self.distanceText = data["distance"]["text"].stringValue
        self.distanceValue = data["distance"]["value"].doubleValue
        self.durationText = data["duration"]["text"].stringValue
        self.durationValue = data["duration"]["value"].doubleValue
        self.arrivalTimeText = data["arrival_time"]["text"].stringValue
        self.arrivalTimeValue = data["arrival_time"]["value"].doubleValue
        self.arrivalTimeTimezone = data["arrival_time"]["time_zone"].doubleValue
        self.departureTimeText = data["departure_time"]["text"].stringValue
        self.departureTimeValue = data["departure_time"]["value"].doubleValue
        self.departureTimeTimezone = data["departure_time"]["time_zone"].doubleValue
        
        //Steps
        var stepItems = [Step]()
        for step in data["steps"].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
    }

}
