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
    
    var allTrains: [Train] = []
    
    var station = ""
    
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
        self.station = station
        options["filter[stop]"] = self.station
        let url = getURL(parameters: options)
        print("\(url)\n")
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(SeparatedServerResponse.self, from: jsonData)
                    self.allTrains = stuff.trains.sorted(by: self.compareTrainsTime)
//                    print(self.allTrains)
//                    print(stuff.trains.sorted(by: self.compareTrainsTime))
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
        sleep(1)
    }
    
    func compareTrainsTime(_ t1: Train, _ t2: Train) -> Bool {
        if t1.arrivalTime != nil && t2.arrivalTime != nil {
            return t1.arrivalTime!.timeIntervalSinceNow <= t2.arrivalTime!.timeIntervalSinceNow
        }
        return false
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
//struct SeparatedServerResponse: Decodable {
//    // final output is a Train class
//    var trains = [Train]()
//
//    init(from decoder: Decoder) throws {
//        // get raw response from above struct
//        let rawResponse = try RawServerResponse(from: decoder)
//
//        // predictions are [G-10xxx : Data]
//        var predictions = [String : RawServerResponse.Data]()
//
//        // predictions with Stops Away don't have a G-10xxx so we have to handle them by the
//        // 36xx-38xx label instead
//        var stopsAwayPredictions = [String : RawServerResponse.Data]()
//
//        // if there is a G-10xxx ID then it is a normal prediction, otherwise if that is nil
//        // it is a 'stops away' prediction
//        for data in rawResponse.data {
//            if data.relationships.vehicle.data?.id != nil {
//                predictions[(data.relationships.vehicle.data?.id)!] = data
//            } else {
//                stopsAwayPredictions[(data.relationships.trip.data?.id)!] = data
//            }
//        }
//        // splitting the 'included' part into two, vehicle and trip (based on the type in the JSON)
//        var vehicles = [String : RawServerResponse.Included]()
//        var trips = [String : RawServerResponse.Included]()
//        for data in rawResponse.included {
//            if data.type == "vehicle" {
//                vehicles[data.id] = data
//            } else if data.type == "trip" && data.relationships.vehicle?.data?.id != nil {
//                trips[(data.relationships.vehicle?.data?.id)!] = data
//            }
//        }
//
//        // combines the data by the G-10xxx ID
//        var combinedData = [CombinedData]()
//        for id in predictions.keys {
//            combinedData.append(CombinedData(id: id, prediction: predictions[id]!, vehicle: vehicles[id]!, trip: trips[id]!, stopsAway: nil))
//        }
//
//        // combines the stopsAway ones into the combinedData
//        // only if they are going in the same direction and the train number exists
//        // removes the value from stopsAwayPredictions; the remaining ones aren't duplicates
//        // and will be added later
//        for train in combinedData {
//            if let numAway = stopsAwayPredictions[(train.vehicle.attributes.label)!] {
////                train.nextStop = numAway.relationships.stop.data?.id
//                if numAway.attributes.direction_id == train.prediction.attributes.direction_id {
//                    train.stopsAway = numAway.attributes.status!
//                    stopsAwayPredictions.removeValue(forKey: (train.vehicle.attributes.label)!)
//                }
//            }
////            } else {
////                combinedData.append(CombinedData(id: nil, predictions))
////            }
//        }
//
//
//
//        //creates Train objects for each prediction excluding ones that are only listed as stops away
//        for glTrain in combinedData {
//            // if the status (like "stopped 1 stop away") is there, include it instead of the stopsAway
//            if glTrain.prediction.attributes.status != nil {
//                glTrain.stopsAway = glTrain.prediction.attributes.status
//            }
//            trains.append(Train(id: glTrain.id,
//                                route: (glTrain.prediction.relationships.route.data!.id)!,
//                                headsign: (glTrain.trip.attributes.headsign)!,
//                                direction: glTrain.prediction.attributes.direction_id,
//                                carNumbers: (glTrain.vehicle.attributes.label)!,
//                                arrivalTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.arrival_time),
//                                departureTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.departure_time),
//                                stopsAway: glTrain.stopsAway,
//                                nextStop: glTrain.vehicle.relationships.stop?.data?.id))
//        }
//
//        combinedData.sort()
//
////        //creates Train objects for remaining 'stops away' predictions
////        for glTrain in stopsAwayPredictions {
////            trains.append(Train(id: nil,
////                                route: glTrain.value.relationships.route.data!.id!,
////                                headsign: getDestination(glTrain.value.relationships.route.data!.id!),
////                                direction: glTrain.value.attributes.direction_id,
////                                carNumbers: glTrain.key,
////                                arrivalTime: nil,
////                                departureTime: nil,
////                                stopsAway: glTrain.value.attributes.status,
////                                nextStop: getNextStop(i: vehicles, trainNum: glTrain.key)))
////
////        }
//
//
//    }
//
//    func getNextStop(i: [String : RawServerResponse.Included], trainNum: String)-> String? {
//        for vehicle in i.values {
//            if vehicle.attributes.label! == trainNum {
//                return (vehicle.relationships.stop!.data?.id)!
//            }
//        }
//        return nil
//    }
//}

struct SeparatedServerResponse: Decodable {
    // final output is a Train class
    var trains = [Train]()
    
    init(from decoder: Decoder) throws {
        // get raw response from above struct
        let rawResponse = try RawServerResponse(from: decoder)
        
        // predictions are [TripID : Data]
        var predictions = [String : RawServerResponse.Data]()
        
        // creating the predictions dictionary
        for data in rawResponse.data {
            predictions[data.relationships.trip.data!.id!] = data
        }
        
        // splitting the 'included' part into two, vehicle and trip (based on the type in the JSON)
        // the TripID is the key
        var vehicles = [String : RawServerResponse.Included]()
        var trips = [String : RawServerResponse.Included]()
        for data in rawResponse.included {
            if data.type == "vehicle" {
                vehicles[data.relationships.trip!.data!.id!] = data
            } else if data.type == "trip" {
                trips[data.id] = data
            }
        }
        
        // combines the data by the TripID
        var combinedData = [CombinedData]()
        for id in predictions.keys {
            combinedData.append(CombinedData(id: id, prediction: predictions[id]!, vehicle: vehicles[id], trip: trips[id]!, stopsAway: nil))
        }
        
        //creates Train objects for each prediction
        for glTrain in combinedData {
            // if the status (like "stopped 1 stop away") is there, include it instead of the stopsAway
            if glTrain.prediction.attributes.status != nil {
                glTrain.stopsAway = glTrain.prediction.attributes.status
            }
            // if glTrain.vehicle is not nil, then the carNumbers and nextStop will be the value
            var carNumbers: String?
            var nextStop: String?
            if let trainData = glTrain.vehicle {
                carNumbers = trainData.attributes.label!
                nextStop = (trainData.relationships.stop?.data?.id!)!
            } else {
                carNumbers = nil
                nextStop = nil
            }
            
            trains.append(Train(id: glTrain.id,
                                route: (glTrain.prediction.relationships.route.data!.id)!,
                                headsign: (glTrain.trip.attributes.headsign)!,
                                direction: glTrain.prediction.attributes.direction_id,
                                carNumbers: carNumbers,
                                arrivalTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.arrival_time),
                                departureTime: getDateOrNilFromString(dateAsString: glTrain.prediction.attributes.departure_time),
                                stopsAway: glTrain.stopsAway,
                                nextStop: nextStop))
        }
        
        combinedData.sort()
    }
    
    func getNextStop(i: [String : RawServerResponse.Included], trainNum: String)-> String? {
        for vehicle in i.values {
            if vehicle.attributes.label! == trainNum {
                return (vehicle.relationships.stop!.data?.id)!
            }
        }
        return nil
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

//infers a destination from a route and direction
func getDestination(_ route: String)-> String {
    switch route {
    case "Green-B":
        return "Boston College"
    case "Green-C":
        return "Cleveland Circle"
    case "Green-D":
        return "Riverside"
    case "Green-E":
        return "Heath Street"
    default:
        return "Unexpected route"
    }
}

// a class to combine a single train into one place with all the data available for that train
class CombinedData : CustomStringConvertible, Comparable {

    
    var id: String?
    var prediction: RawServerResponse.Data
    var vehicle: RawServerResponse.Included?
    var trip: RawServerResponse.Included
    var stopsAway: String?
    
    init(id: String?, prediction: RawServerResponse.Data, vehicle: RawServerResponse.Included?, trip: RawServerResponse.Included, stopsAway: String?) {
        self.id = id
        self.prediction = prediction
        self.vehicle = vehicle
        self.trip = trip
        self.stopsAway = stopsAway
    }
    
    //custom string convertible description so it's possible to print
    var description: String {
        var d = ""
        d += "ID: \(String(describing: id))\n"
        d += "Route: \(String(describing: prediction.relationships.route.data!.id))\n"
        d += "Headsign: \(String(describing: trip.attributes.headsign))\n"
        d += "Direction: \(prediction.attributes.direction_id)\n"
        d += "Car Numbers: \(String(describing: vehicle?.attributes.label))\n"
        d += "Arrival Time: \(String(describing: prediction.attributes.arrival_time))\n"
        d += "Departure Time: \(String(describing: prediction.attributes.departure_time))\n"
        d += "Stops Away: \(String(describing: stopsAway))\n\n"
        return d
    }
    
    static func < (lhs: CombinedData, rhs: CombinedData) -> Bool {
        if let arr1 = lhs.prediction.attributes.arrival_time,
            let arr2 = rhs.prediction.attributes.arrival_time {
            let d1 = df.date(from: arr1)
            let d2 = df.date(from: arr2)
            return (d1!.compare(d2!)).rawValue < 0
        }
        return false
    }
   

    static func == (lhs: CombinedData, rhs: CombinedData) -> Bool {
        if let arr1 = lhs.prediction.attributes.arrival_time,
            let arr2 = rhs.prediction.attributes.arrival_time {
            let d1 = df.date(from: arr1)
            let d2 = df.date(from: arr2)
            return (d1!.compare(d2!)).rawValue == 0
        }
        return false
    }

    
}

//.timeIntervalSinceNow gets seconds until date
