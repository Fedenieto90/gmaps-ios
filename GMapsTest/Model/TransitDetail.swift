//
//  TransitDetail.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransitDetail: NSObject {
    
    var arrivalStopName : String
    var arrivalStopLat : Double
    var arrivalStopLong : Double
    
    var arrivalTimeText : String
    var arrivalTimeValue : Double
    var arrivalTimeTimezone : String
    
    var departureStopName : String
    var departureStopLat : Double
    var departureStopLong : Double
    
    var departureTimeText : String
    var departureTimeValue : Double
    var departureTimeTimezone : String
    
    var headsSign : String
    var numberOfStops : Int
    
    var line : Line
    
    init(data: JSON) {
        
        self.arrivalStopName = data["arrival_stop"]["name"].stringValue
        self.arrivalStopLat = data["arrival_stop"]["location"]["lat"].doubleValue
        self.arrivalStopLong = data["arrival_stop"]["location"]["lng"].doubleValue
        
        self.arrivalTimeText = data["arrival_time"]["text"].stringValue
        self.arrivalTimeValue = data["arrival_time"]["value"].doubleValue
        self.arrivalTimeTimezone = data["arrival_time"]["time_zone"].stringValue
        
        self.departureStopName = data["departure_stop"]["name"].stringValue
        self.departureStopLat = data["departure_stop"]["location"]["lat"].doubleValue
        self.departureStopLong = data["departure_stop"]["location"]["lng"].doubleValue
        
        self.departureTimeText = data["departure_time"]["text"].stringValue
        self.departureTimeValue = data["departure_time"]["value"].doubleValue
        self.departureTimeTimezone = data["departure_time"]["time_zone"].stringValue
        
        self.headsSign = data["headsign"].stringValue
        self.numberOfStops = data["num_stops"].intValue

        self.line = Line(data: data["line"] as JSON)
    }

}
