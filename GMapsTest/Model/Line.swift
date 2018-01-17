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
    var lineNumber : String

    init(data: JSON) {
        self.name = data["name"].stringValue
        self.lineNumber = data["short_name"].stringValue
    }
}
