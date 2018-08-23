//
//  Train.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class Train {
    
    let route: String // Green-B, Green-C, Green-D, Green-E
    let direction: String // 0 = Westbound, 1 = Eastbound
    let carNumbers: String // 36xx-38xx
    let arrivalTime: Date? // arrival time for all stations except downtown WB stations
    let departureTime: Date?
    let stopsAway: Int? // stops away for downtown WB stations
    
    init(route: String, direction: String, carNumbers: String, arrivalTime: Date?, departureTime: Date?, stopsAway: Int?) {
        self.route = route
        self.direction = direction
        self.carNumbers = carNumbers
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.stopsAway = stopsAway
    }
    
}
