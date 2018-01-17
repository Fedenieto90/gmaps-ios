//
//  Route.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class Route: NSObject {

    var copyrights : String
    var legs : [Leg]
    
    init(data : JSON) {
        self.copyrights = data["copyrights"].stringValue
        var legItems = [Leg]()
        for leg in data["legs"].arrayValue {
            let legItem = Leg(data: leg)
            legItems.append(legItem)
        }
        self.legs = legItems
    }
}
