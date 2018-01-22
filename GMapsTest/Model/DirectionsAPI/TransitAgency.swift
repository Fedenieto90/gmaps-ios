//
//  TransitAgency.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/22/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

private struct Keys {
    static let name = "name"
    static let url = "url"
    static let phone = "phone"
}

class TransitAgency: NSObject {
    
    var name : String
    var url : String
    var phone : String
    
    init(data: JSON) {
        self.name = data[Keys.name].stringValue
        self.url = data[Keys.url].stringValue
        self.phone = data[Keys.phone].stringValue
    }

}
