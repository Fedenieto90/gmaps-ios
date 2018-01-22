//
//  Line.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let name = "name"
    static let shortName = "short_name"
    static let url = "url"
    static let icon = "icon"
    static let textColor = "text_color"
    static let color = "color"
    static let vehicle = "vehicle"
}

class Line: NSObject {
    
    var name : String
    var number : String
    var color : UIColor
    var url : String
    var icon : String
    var textColor : UIColor
    var lineVehicle : LineVehicle

    init(data: JSON) {
        self.name = data[Keys.name].stringValue
        self.number = data[Keys.shortName].stringValue
        self.url = data[Keys.url].stringValue
        self.icon = data[Keys.icon].stringValue
        self.textColor = UIColor.hexStringToUIColor(hex: data[Keys.textColor].stringValue)
        self.color = UIColor.hexStringToUIColor(hex: data[Keys.color].stringValue)
        self.lineVehicle = LineVehicle(data: data[Keys.vehicle] as JSON)
    }
}
