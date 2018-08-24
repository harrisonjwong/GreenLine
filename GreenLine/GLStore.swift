//
//  GLStore.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import Foundation

// Date format that the arrival and departure times come in
let df: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
}()

class GLStore {
    
    //options that allow us to select the Green Line and predictions
    var options = ["filter[route]": "Green-B,Green-C,Green-D,Green-E", "include": "vehicle,trip"]
    
    let baseURLString = "https://api-v3.mbta.com/predictions"
    let apiKey = "eb4cde2daae74dcfbbf324987283b2d4"
    
    // gets the API url based on given parameters
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
    
    func fetchData(station: String) {
        options["filter[stop]"] = station
        let url = getURL(parameters: options)
        print("\(url)\n")
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(SeparatedServerResponse.self, from: jsonData)
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

// a way to get all the data from the JSON
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

    var data: [Data]
    var included: [Included]
    var jsonapi: jsonApi
    struct jsonApi: Codable {
        var version: String
    }
    
}

//runs the RawServerResponse on the JSON then combines the data into a Train
struct SeparatedServerResponse: Decodable {
    // final output is a Train class
    var trains = [Train]()

    init(from decoder: Decoder) throws {
        // get raw response from above struct
        let rawResponse = try RawServerResponse(from: decoder)
        
        // predictions are [G-10xxx : Data]
        var predictions = [String : RawServerResponse.Data]()
        
        // predictions with Stops Away don't have a G-10xxx so we have to handle them by the
        // 36xx-38xx label instead
        var stopsAwayPredictions = [String : String]()
        
        // if there is a G-10xxx ID then it is a normal prediction, otherwise if that is nil
        // it is a 'stops away' prediction
        for data in rawResponse.data {
            if data.relationships.vehicle.data?.id != nil {
                predictions[(data.relationships.vehicle.data?.id)!] = data
            } else {
                stopsAwayPredictions[(data.relationships.trip.data?.id)!] = data.attributes.status!
            }
        }
        // splitting the 'included' part into two, vehicle and trip (based on the type in the JSON)
        var vehicles = [String : RawServerResponse.Included]()
        var trips = [String : RawServerResponse.Included]()
        for data in rawResponse.included {
            if data.type == "vehicle" {
                vehicles[data.id] = data
            } else {
                trips[(data.relationships.vehicle?.data?.id)!] = data
            }
        }
        
        // combines the data by the G-10xxx ID
        var combinedData = [CombinedData]()
        for id in predictions.keys {
            combinedData.append(CombinedData(id: id, prediction: predictions[id]!, vehicle: vehicles[id]!, trip: trips[id]!, stopsAway: nil))
        }
        
        // MAYBE need to find a better way to do this because it loops again
        // combines the stopsAway ones into the combinedData
        for train in combinedData {
            if let numAway = stopsAwayPredictions[(train.vehicle.attributes.label)!] {
                train.stopsAway = numAway
            }
        }
        
        //creates Train objects for each prediction
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

//turns the string optional from JSON into a Date or remains a nil if it doesn't exist
func getDateOrNilFromString(dateAsString: String?)-> Date? {
    if dateAsString != nil {
        return df.date(from: dateAsString!)
    } else {
        return nil
    }
}

// a class to combine a single train into one place with all the data available for that train
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
    
    //custom string convertible description so it's possible to print
    var description: String {
        var d = ""
        d += "ID: \(id)\n"
        d += "Route: \(String(describing: prediction.relationships.route.data!.id))\n"
        d += "Headsign: \(String(describing: trip.attributes.headsign))\n"
        d += "Direction: \(prediction.attributes.direction_id)\n"
        d += "Car Numbers: \(String(describing: vehicle.attributes.label))\n"
        d += "Arrival Time: \(String(describing: prediction.attributes.arrival_time))\n"
        d += "Departure Time: \(String(describing: prediction.attributes.departure_time))\n"
        d += "Stops Away: \(String(describing: stopsAway))\n\n"
        return d
    }
}

//.timeIntervalSinceNow gets seconds until date
