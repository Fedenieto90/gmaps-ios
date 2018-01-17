//
//  TransitDetail.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransitDetail: NSObject {
    
    var arrivalStopName : String
    
    init(data: JSON) {
        self.arrivalStopName = data["arrival_stop"]["name"].stringValue
    }

}
