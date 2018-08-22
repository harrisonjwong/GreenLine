//
//  GLStore.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

class GLStore {
    
    let options = ["filter[route]": "Green-B,Green-C,Green-D,Green-E", "include": "vehicle,trip", "filter[stop]": "place-chhil"]
    
    let baseURLString = "https://api-v3.mbta.com/predictions"
    let apiKey = "eb4cde2daae74dcfbbf324987283b2d4"
    
    func getURL(parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchData() {
        let url = getURL(parameters: options)
        print(url)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let jsonObject: AnyObject
                        = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
//                    let jsonDictionary = JSONDecoder().decode(RawServerResponse, from: jsonObject)
                    let decoder = JSONDecoder()
//                    print(jsonObject)
                    do {
                        let stuff = try decoder.decode(RawServerResponse.self, from: jsonData)
                        print(stuff)
                    } catch {
                        print("error trying to convert data to JSON")
                        print(error)
                    }
                    
                } catch let error {
                    print("Error creating JSON object: \(error)")
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

struct RawServerResponse: Codable {
    struct data: Codable {
        var attributes: AttributesData
        var id: String
        var relationships: Relationships
        var type: String
    }
    struct AttributesData: Codable {
        var arrival_time: String
        var departure_time: String
        var direction_id: Int
        var schedule_relationship: String
        var status: String
        var stop_sequence: Int
    }
    struct Relationships: Codable {
        var route: DataWithIdAndType
        var stop: DataWithIdAndType
        var trip: DataWithIdAndType
        var vehicle: DataWithIdAndType
    }
    struct DataWithIdAndType: Codable {
        var data: DataWithIdType
    }
    struct DataWithIdType: Codable {
        var id: String
        var type: String
    }
    struct included: Codable {
        var attributes: AttributesIncluded
        var id: String
        var links: Links
        var relationships: Relationships
        var type: String
    }
    struct AttributesIncluded: Codable {
        //first type - trip
        var block_id: String?
        var direction_id: Int? // used in both types
        var headsign: String?
        var name: String?
        var wheelchair_accessible: Int?
        //second type - vehicle
        var bearing: Int?
        var current_status: String?
        var current_stop_sequence: Int?
        var label: String?
        var latitude: Int?
        var longitude: Int?
        var speed: Int?
        var updated_at: String?
    }
    struct Links: Codable {
        var self1: String
    }
    var jsonapi: jsonApi
    struct jsonApi: Codable {
        var version: String
    }
}

struct ServerResponse: Decodable {
    
}

// data -> # -> attributes -> arrival_time
// data -> # -> attributes -> direction_id
// data -> # -> attributes -> label
// data -> # -> attributes -> status
// data -> # -> relationships -> route -> data -> id
