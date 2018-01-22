//
//  LineVehicle.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/18/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import SwiftyJSON

public enum VehicleType : String {
    case rail = "RAIL"
    case metroRail = "METRO_RAIL"
    case subway = "SUBWAY"
    case tram = "TRAM"
    case monorail = "MONORAIL"
    case heavyRail = "HEAVY_RAIL"
    case commuterTrain = "COMMUTER_TRAIN"
    case highSpeedTrain = "HIGH_SPEED_TRAIN"
    case bus = "BUS"
    case intercityBus = "INTERCITY_BUS"
    case trolleybus = "TROLLEYBUS"
    case shareTaxi = "SHARE_TAXI"
    case ferry = "Ferry"
    case cableCar = "CABLE_CAR"
    case gondolaLift = "GONDOLA_LIFT"
    case funicular = "FUNICULAR"
    case other = "OTHER"
}

private struct Keys {
    static let name = "name"
    static let type = "type"
    static let icon = "icon"
    static let localIcon = "local_icon"
}

class LineVehicle: NSObject {

    var name : String
    var type : VehicleType
    var icon : String
    var localIcon : String
    
    init(data: JSON) {
        self.name = data[Keys.name].stringValue
        let vehicleType = data[Keys.type].stringValue
        if vehicleType == VehicleType.rail.rawValue {
            self.type = .rail
        } else if vehicleType == VehicleType.bus.rawValue {
            self.type = .bus
        } else if vehicleType == VehicleType.cableCar.rawValue {
            self.type = .cableCar
        } else if vehicleType == VehicleType.commuterTrain.rawValue {
            self.type = .commuterTrain
        } else if vehicleType == VehicleType.ferry.rawValue {
            self.type = .ferry
        } else if vehicleType == VehicleType.funicular.rawValue {
            self.type = .funicular
        } else if vehicleType == VehicleType.gondolaLift.rawValue {
            self.type = .gondolaLift
        } else if vehicleType == VehicleType.heavyRail.rawValue {
            self.type = .heavyRail
        } else if vehicleType == VehicleType.highSpeedTrain.rawValue {
            self.type = .highSpeedTrain
        } else if vehicleType == VehicleType.intercityBus.rawValue {
            self.type = .intercityBus
        } else if vehicleType == VehicleType.metroRail.rawValue {
            self.type = .metroRail
        } else if vehicleType == VehicleType.monorail.rawValue {
            self.type = .monorail
        } else if vehicleType == VehicleType.subway.rawValue {
            self.type = .subway
        } else if vehicleType == VehicleType.tram.rawValue {
            self.type = .tram
        } else if vehicleType == VehicleType.trolleybus.rawValue {
            self.type = .trolleybus
        } else if vehicleType == VehicleType.shareTaxi.rawValue {
            self.type = .shareTaxi
        } else {
            self.type = .other
        }
        self.icon = data[Keys.icon].stringValue
        self.localIcon = data[Keys.localIcon].stringValue
    }
}
