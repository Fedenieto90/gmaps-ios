//
//  LineVehicle.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/18/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let name = "name"
    static let type = "type"
    static let icon = "icon"
    static let localIcon = "local_icon"
}

class LineVehicle: NSObject {

    var name : String
    var type : String
    var icon : String
    var localIcon : String
    
    init(data: JSON) {
        self.name = data[Keys.name].stringValue
        self.type = data[Keys.type].stringValue
        self.icon = data[Keys.icon].stringValue
        self.localIcon = data[Keys.localIcon].stringValue
    }
}
