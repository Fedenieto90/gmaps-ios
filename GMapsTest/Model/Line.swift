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

    init(data: JSON) {
        self.name = data["name"].stringValue
        self.number = data["short_name"].stringValue
        self.color = UIColor().hexStringToUIColor(hex: data["color"].stringValue)
    }
}
