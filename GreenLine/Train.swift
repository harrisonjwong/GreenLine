//
//  Train.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class Train : CustomStringConvertible, Comparable {
    
    var stationStore = StationStore()
    
    let id: String? // G-10xxx
    let route: String // Green-B, Green-C, Green-D, Green-E
    let headsign: String? // Riverside
    let direction: Int // 0 = Westbound, 1 = Eastbound
    let carNumbers: String? // 36xx-38xx
    let arrivalTime: Date? // arrival time for all stations except downtown WB stations
    let departureTime: Date?
    let stopsAway: String? // stops away for downtown WB stations
    var nextStop: String? // current location of train
    
    init(id: String?, route: String, headsign: String?, direction: Int, carNumbers: String?, arrivalTime: Date?, departureTime: Date?, stopsAway: String?, nextStop: String?) {
        self.id = id
        self.route = route
        self.headsign = headsign
        self.direction = direction
        self.carNumbers = carNumbers
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.stopsAway = stopsAway
        self.nextStop = nextStop
        if nextStop != nil {
            let name = stationStore.stationsByID[nextStop!]
            self.nextStop = name
        } else {
            self.nextStop = nextStop
        }
    }
    
    var description: String {
        var d = ""
        d += "\nID: \(String(describing: id)) \nRoute: \(route) \nHeadsign: \(String(describing: headsign)) \nDirection: \(direction) \nCar Numbers: \(String(describing: carNumbers))"
        d += "\nArrival Time: \(String(describing: getTimeInMinSec(arrivalTime)))"
        d += "\nDeparture Time: \(String(describing: getTimeInMinSec(departureTime)))"
        d += "\nStops Away: \(String(describing: stopsAway))"
        d += "\nNext stop: \(String(describing: nextStop))\n\n"
        return d
    }
    
    func getTimeInMinSec(_ d: Date?)-> String? {
        if d != nil {
            let min = floor(d!.timeIntervalSinceNow/60)
            let sec = round(d!.timeIntervalSinceNow.truncatingRemainder(dividingBy: 60))
            return "\(min)m \(sec)s"
        }
        return nil
    }
    
    var date: Date? {
        if let arr = self.arrivalTime {
            return arr
        } else if let dpt = self.departureTime {
            return dpt
        } else {
            return nil
        }
    }
    
    static func < (lhs: Train, rhs: Train) -> Bool {
        if let time1 = lhs.date,
            let time2 = rhs.date {
            return (time1.compare(time2)).rawValue < 0
        }
        return false
    }
    
    
    static func == (lhs: Train, rhs: Train) -> Bool {
        if let time1 = lhs.date,
            let time2 = rhs.date {
            return (time1.compare(time2)).rawValue == 0
        }
        return false
    }
    

}
