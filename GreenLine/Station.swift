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
    let trains: [Train]
    
    init(name: String, id: String, trains: [Train]) {
        self.name = name
        self.id = id
        self.trains = trains
    }
}
