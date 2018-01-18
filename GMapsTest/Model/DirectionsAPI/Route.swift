//
//  Route.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let copyrights = "copyrights"
    static let overviewPolyline = "overview_polyline"
    static let points = "points"
    static let legs = "legs"
    static let summary = "summary"
    static let warnings = "warnings"
}

class Route: NSObject {

    var copyrights : String
    var overviewPolylinePoints : String
    var summary : String
    var warnings : [String]
    var legs : [Leg]
    
    init(data : JSON) {
        self.copyrights = data[Keys.copyrights].stringValue
        self.overviewPolylinePoints = data[Keys.overviewPolyline][Keys.points].stringValue
        self.summary = data[Keys.summary].stringValue
        
        //Legs
        var legItems = [Leg]()
        for leg in data[Keys.legs].arrayValue {
            let legItem = Leg(data: leg)
            legItems.append(legItem)
        }
        self.legs = legItems
        
        //Warnings
        var warningItems = [String]()
        for warning in data[Keys.warnings].arrayValue {
            warningItems.append(warning.stringValue)
        }
        self.warnings = warningItems
    }
}
