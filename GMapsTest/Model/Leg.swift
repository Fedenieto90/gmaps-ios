//
//  Leg.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class Leg: NSObject {
    
    var startAdress : String
    var endAddress : String
    var steps : [Step]
    
    init(data : JSON) {
        self.startAdress = data["start_address"].stringValue
        self.endAddress = data["end_address"].stringValue
        
        var stepItems = [Step]()
        for step in data["steps"].arrayValue {
            let stepItem = Step(data: step)
            stepItems.append(stepItem)
        }
        self.steps = stepItems
    }

}
