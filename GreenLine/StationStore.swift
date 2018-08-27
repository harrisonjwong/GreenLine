//
//  StationStore.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/27/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class StationStore {
    
    let url = "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&format=json&nojsoncallback=1&filter[route]=Green-B,Green-C,Green-D,Green-E&include=child_stops"
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchData() {
        let urlAsURL = URL(string: url)
        let request = URLRequest(url: urlAsURL!)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(SeparatedServerResponseStations.self, from: jsonData)
                    print(stuff)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                }
            }
            else if let requestError = error {
                print("Error: \(requestError)")
            }
            else {
                print("Unexpected error")
            }
        }
        task.resume()
    }
}

struct RawServerResponseStations : Decodable {
    
    struct Data: Decodable {
        var attributes: Attributes2
        var id: String
        var relationships: Relationships2
    }
    
    struct Attributes2: Decodable {
        var name: String
    }
    
    struct Relationships2: Decodable {
        var child_stops: DataWithNameID
    }
    
    struct DataWithNameID: Decodable {
        var data1: DataWithNameID2?
        var data2: DataWithNameID2?
    }
    
    struct DataWithNameID2: Decodable {
        var id: String
        var type: String
    }
    
    var data: [Data]
}

struct SeparatedServerResponseStations : Decodable {
    var stations = [Station]()
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStations(from: decoder)
        
        for d in rawResponse.data {
            stations.append(Station(name: d.attributes.name, id: d.id, platformID1: d.relationships.child_stops.data1?.id, platformID2: d.relationships.child_stops.data2?.id))
        }
    }
}