//
//  LineVehicle.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/18/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class LineVehicle: NSObject {

    var name : String
    var type : String
    var icon : String
    var localIcon : String
    
    init(data: JSON) {
        self.name = data["name"].stringValue
        self.type = data["type"].stringValue
        self.icon = data["icon"].stringValue
        self.localIcon = data["local_icon"].stringValue
    }
}
