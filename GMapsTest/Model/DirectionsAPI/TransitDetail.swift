//
//  TransitDetail.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let arrivalStop = "arrival_stop"
    static let name = "name"
    static let location = "location"
    static let latitude = "lat"
    static let longitude = "lng"
    static let arrivalTime = "arrival_time"
    static let departureStop = "departure_stop"
    static let departureTime = "departure_time"
    static let text = "text"
    static let value = "value"
    static let timeZone = "time_zone"
    static let headsign = "headsign"
    static let headway = "headway"
    static let numberOfStops = "num_stops"
    static let line = "line"
}

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
    
    var headsign : String
    var headway : String
    var numberOfStops : Int
    
    var line : Line
    
    init(data: JSON) {
        
        self.arrivalStopName = data[Keys.arrivalStop][Keys.name].stringValue
        self.arrivalStopLat = data[Keys.arrivalStop][Keys.location][Keys.latitude].doubleValue
        self.arrivalStopLong = data[Keys.arrivalStop][Keys.location][Keys.longitude].doubleValue
        
        self.arrivalTimeText = data[Keys.arrivalTime][Keys.text].stringValue
        self.arrivalTimeValue = data[Keys.arrivalTime][Keys.value].doubleValue
        self.arrivalTimeTimezone = data[Keys.arrivalTime][Keys.timeZone].stringValue
        
        self.departureStopName = data[Keys.departureStop][Keys.name].stringValue
        self.departureStopLat = data[Keys.departureStop][Keys.location][Keys.latitude].doubleValue
        self.departureStopLong = data[Keys.departureStop][Keys.location][Keys.longitude].doubleValue
        
        self.departureTimeText = data[Keys.departureTime][Keys.text].stringValue
        self.departureTimeValue = data[Keys.departureTime][Keys.value].doubleValue
        self.departureTimeTimezone = data[Keys.departureTime][Keys.timeZone].stringValue
        
        self.headsign = data[Keys.headsign].stringValue
        self.headway = data[Keys.headway].stringValue
        self.numberOfStops = data[Keys.numberOfStops].intValue

        self.line = Line(data: data[Keys.line] as JSON)
    }

}
