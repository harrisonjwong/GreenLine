//
//  GLStore.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

let df: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
}()

class GLStore {
    
    var options = ["filter[route]": "Green-B,Green-C,Green-D,Green-E", "include": "vehicle,trip"]
    
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
    
//    df.locale = Locale(identifier: "en_US_POSIX")
//    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//    df.timeZone = TimeZone(secondsFromGMT: 0)
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "M/dd/yyyy h:mm a"
//        return formatter
//    }()
    
    func fetchData(station: String) {
        options["filter[stop]"] = station
        let url = getURL(parameters: options)
        print(url)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    do {
                        let stuff = try decoder.decode(SeparatedServerResponse.self, from: jsonData)
//                        print(stuff)
//                        for i in stuff.data {
//                            var d = i.attributes.arrival_time
//                            if d != nil {
//                                print(self.df.date(from: d!)?.timeIntervalSinceNow)
//                            } else {
//                                print(i.attributes.status)
//                            }
//                        }
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
    struct Data: Codable {
        var attributes: AttributesData
        var id: String?
        var relationships: RelationshipsData
        var type: String
    }
    struct AttributesData: Codable {
        var arrival_time: String?
        var departure_time: String?
        var direction_id: Int
        var schedule_relationship: String?
        var status: String?
        var stop_sequence: Int?
    }
    struct RelationshipsData: Codable {
        var route: DataWithIdAndType
        var stop: DataWithIdAndType
        var trip: DataWithIdAndType
        var vehicle: DataWithIdAndType
    }
    struct DataWithIdAndType: Codable {
        var data: DataWithIdType?
    }
    struct DataWithIdType: Codable {
        var id: String?
        var type: String?
    }
    struct Included: Codable {
        var attributes: AttributesIncluded
        var id: String
//        var links: Links
        var relationships: RelationshipsIncluded
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
        var latitude: Double?
        var longitude: Double?
        var speed: Int?
        var updated_at: String?
    }
    struct RelationshipsIncluded: Codable {
        // trip = route, service, shape, vehicle
        // vehicle = route, stop, trip
        var route: DataWithIdAndType
        var service: DataWithIdAndType?
        var stop: DataWithIdAndType?
        var trip: DataWithIdAndType?
        var shape: DataWithIdAndType?
        var vehicle: DataWithIdAndType?
        
        
    }
//    struct Links: Codable {
//        var self1: String
//    }
    
    var data: [Data]
    var included: [Included]
    var jsonapi: jsonApi
    struct jsonApi: Codable {
        var version: String
    }
}

struct SeparatedServerResponse: Decodable {
    var trains = [Train]()

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponse(from: decoder)

        // Now you can pick items that are important to your data model,
        // conveniently decoded into a Swift structure
        
        var predictions = [String : RawServerResponse.Data]()
        var stopsAwayPredictions = [String : String]()
        for data in rawResponse.data {
            if data.relationships.vehicle.data?.id != nil {
                predictions[(data.relationships.vehicle.data?.id)!] = data
            } else {
                stopsAwayPredictions[(data.relationships.trip.data?.id)!] = data.attributes.status!
            }
        }
        var vehicles = [String : RawServerResponse.Included]()
        var trips = [String : RawServerResponse.Included]()
        for data in rawResponse.included {
            if data.type == "vehicle" {
                vehicles[data.id] = data
            } else {
                trips[(data.relationships.vehicle?.data?.id)!] = data
            }
        }
//        print(predictions.keys)
//        print(vehicles.keys)
//        print(trips.keys)
        
        var combinedData = [CombinedData]()
        for id in predictions.keys {
            combinedData.append(CombinedData(id: id, prediction: predictions[id]!, vehicle: vehicles[id]!, trip: trips[id]!, stopsAway: nil))
        }
        
//        print(combinedData)
        // MAYBE need to find a better way to do this because it loops again
        for train in combinedData {
            if let numAway = stopsAwayPredictions[(train.vehicle.attributes.label)!] {
                train.stopsAway = numAway
            }

        }
        //        print(combinedData)
        
        for glTrain in combinedData {
            trains.append(Train(id: glTrain.id,
                                route: (glTrain.prediction.relationships.route.data!.id)!,
                                headsign: (glTrain.trip.attributes.headsign)!,
                                direction: glTrain.prediction.attributes.direction_id,
                                carNumbers: (glTrain.vehicle.attributes.label)!,
                                arrivalTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.arrival_time),
                                departureTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.departure_time),
                                stopsAway: glTrain.stopsAway))
        }
        
    }
}

func getDateOrNilFromString(dateAsString: String?)-> Date? {
    if dateAsString != nil {
        return df.date(from: dateAsString!)
    } else {
        return nil
    }
}

class CombinedData : CustomStringConvertible {
    var id: String
    var prediction: RawServerResponse.Data
    var vehicle: RawServerResponse.Included
    var trip: RawServerResponse.Included
    var stopsAway: String?
    
    init(id: String, prediction: RawServerResponse.Data, vehicle: RawServerResponse.Included, trip: RawServerResponse.Included, stopsAway: String?) {
        self.id = id
        self.prediction = prediction
        self.vehicle = vehicle
        self.trip = trip
        self.stopsAway = stopsAway
    }
    var description: String {
        return "ID: \(id)\n Route: \(prediction.relationships.route.data!.id)\n Headsign: \(trip.attributes.headsign)\n Direction: \(prediction.attributes.direction_id)\n Car Numbers: \(vehicle.attributes.label)\n Arrival Time: \(prediction.attributes.arrival_time)\n Departure Time: \(prediction.attributes.departure_time)\n Stops Away: \(stopsAway)\n\n"
    }
}

// data -> # -> attributes -> arrival_time
// data -> # -> attributes -> direction_id
// data -> # -> attributes -> label
// data -> # -> attributes -> status
// data -> # -> relationships -> route -> data -> id
//.timeIntervalSinceNow
