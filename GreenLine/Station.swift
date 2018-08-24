//
//  Station.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class Station {
    let name: String
    let id: String
    let routes: [String]
//    let trains: [Train]
    
    init(name: String, id: String, routes: [String]) {
        self.name = name
        self.id = id
        self.routes = routes
    }
}

struct Constants {
    let dBranchStations = [
        "Riverside" : Station(name: "Riverside", id: "place-river", routes: ["Green-D"]),
        "Woodland" : Station(name: "Woodland", id: "place-woodl", routes: ["Green-D"]),
        "Waban" : Station(name: "Waban", id: "place-waban", routes: ["Green-D"]),
        "Eliot" : Station(name: "Eliot", id: "place-eliot", routes: ["Green-D"]),
        "Newton Highlands" : Station(name: "Newton Highlands", id: "place-newtn", routes: ["Green-D"]),
        "Newton Centre" : Station(name: "Newton Centre", id: "place-newto", routes: ["Green-D"]),
        "Chestnut Hill" : Station(name: "Chestnut Hill", id: "place-chhil", routes: ["Green-D"]),
        "Reservoir" : Station(name: "Reservoir", id: "place-rsnml", routes: ["Green-D"]),
        "Beaconsfield" : Station(name: "Beaconsfield", id: "place-bcnfd", routes: ["Green-D"]),
        "Brookline Hills" : Station(name: "Brookline Hills", id: "place-brhkl", routes: ["Green-D"]),
        "Brookline Village" : Station(name: "Brookline Village", id: "place-bvmnl", routes: ["Green-D"]),
        "Longwood" : Station(name: "Longwood", id: "place-longw", routes: ["Green-D"]),
        "Fenway" : Station(name: "Fenway", id: "place-fenwy", routes: ["Green-D"]),
        "Kenmore" : Station(name: "Kenmore", id: "place-kencl", routes: ["Green-B", "Green-C", "Green-D"]),
        "Hynes Convention Center" : Station(name: "Hynes Convention Center", id: "place-hymnl", routes: ["Green-B", "Green-C", "Green-D"]),
        "Copley" : Station(name: "Copley", id: "place-coecl", routes: ["Green-B", "Green-C", "Green-D", "Green-E"]),
        "Arlington" : Station(name: "Arlington", id: "place-armnl", routes: ["Green-B", "Green-C", "Green-D", "Green-E"]),
        "Boylston" : Station(name: "Boylston", id: "place-boyls", routes: ["Green-B", "Green-C", "Green-D", "Green-E"]),
        "Park Street" : Station(name: "Park Street", id: "place-pktrm", routes: ["Green-B", "Green-C", "Green-D", "Green-E"]),
        "Government Center" : Station(name: "Government Center", id: "place-gover", routes: ["Green-C", "Green-D", "Green-E"])]
    
}
