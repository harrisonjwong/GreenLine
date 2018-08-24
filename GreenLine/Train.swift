//
//  Train.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class Train : CustomStringConvertible {
    
    let id: String // G-10xxx
    let route: String // Green-B, Green-C, Green-D, Green-E
    let headsign: String // Riverside
    let direction: Int // 0 = Westbound, 1 = Eastbound
    let carNumbers: String // 36xx-38xx
    let arrivalTime: Date? // arrival time for all stations except downtown WB stations
    let departureTime: Date?
    let stopsAway: String? // stops away for downtown WB stations
    
    init(id: String, route: String, headsign: String, direction: Int, carNumbers: String, arrivalTime: Date?, departureTime: Date?, stopsAway: String?) {
        self.id = id
        self.route = route
        self.headsign = headsign
        self.direction = direction
        self.carNumbers = carNumbers
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.stopsAway = stopsAway
    }
    
    var description: String {
        return "\nID: \(id) \nRoute: \(route) \nHeadsign: \(headsign) \nDirection: \(direction) \nCar Numbers: \(carNumbers) \nArrival Time: \(arrivalTime) \nDeparture Time: \(departureTime) \nStops Away: \(stopsAway)\n\n"
    }
}
