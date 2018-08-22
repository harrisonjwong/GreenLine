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
//                    print(jsonData)
                    do {
                        let todo = try decoder.decode(RawServerResponse.self, from: jsonData)
                        print(todo)
//                        completionHandler(todo, nil)
                    } catch {
                        print("error trying to convert data to JSON")
                        print(error)
//                        completionHandler(nil, error)
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
    
    
 /*
    enum TrainResult {
        case Success([Train])
        case Failure(Error)
    }
    
    enum TrainError: Error {
        case InvalidJSONData
    }
    
    static func trainsFromJSONData(data: Data) -> TrainResult {
        do {
            let jsonObject: AnyObject
                = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let
            jsonDictionary = jsonObject as? [NSObject:AnyObject],
                photos
            
            var finalTrains = [Train]()
            return .Success(finalTrains)
        }
        catch let error {
            return .Failure(error)
        }
    }
 */
}

struct RawServerResponse: Decodable {
    struct data: Decodable {
        struct attributes: Decodable {
            var arrival: String
            var departure: String
            var direction: Int
            var status: String
        }
        struct relationships: Decodable {
            struct route: Decodable {
                struct data: Decodable {
                    var destination: String
                }
            }
            struct trip: Decodable {
                struct data: Decodable {
                    var trainNum: String
                }
            }
        }
    }
    struct included: Decodable {
        struct attributes: Decodable {
            var headsign: String
            var label: String
        }
        var id: String
    }
}

struct ServerResponse: Decodable {
    
}

// data -> # -> attributes -> arrival_time
// data -> # -> attributes -> direction_id
// data -> # -> attributes -> label
// data -> # -> attributes -> status
// data -> # -> relationships -> route -> data -> id
