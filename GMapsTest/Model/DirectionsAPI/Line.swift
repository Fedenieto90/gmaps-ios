//
//  Line.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class Line: NSObject {
    
    var name : String
    var number : String
    var color : UIColor
    var url : String
    var icon : String
    var textColor : UIColor
    var lineVehicle : LineVehicle

    init(data: JSON) {
        self.name = data["name"].stringValue
        self.number = data["short_name"].stringValue
        self.url = data["url"].stringValue
        self.icon = data["icon"].stringValue
        self.textColor = UIColor.hexStringToUIColor(hex: data["text_color"].stringValue)
        self.color = UIColor.hexStringToUIColor(hex: data["color"].stringValue)
        self.lineVehicle = LineVehicle(data: data["vehicle"] as JSON)
    }
}
