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
    
    //code used to get list of stations
    var bURL = URL(string: "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&format=json&nojsoncallback=1&filter[route]=Green-B&include=child_stops")
    var cURL = URL(string: "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&format=json&nojsoncallback=1&filter[route]=Green-C&include=child_stops")
    var dURL = URL(string: "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&format=json&nojsoncallback=1&filter[route]=Green-D&include=child_stops")
    var eURL = URL(string: "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&format=json&nojsoncallback=1&filter[route]=Green-E&include=child_stops")
    
    func fetchLineStations() {
        let request = URLRequest(url: eURL!)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(StationListingServerResponse.self, from: jsonData)
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
    
    let bStations = ["Boston College", "South Street", "Chestnut Hill Avenue", "Chiswick Road", "Sutherland Road", "Washington Street", "Warren Street", "Allston Street", "Griggs Street", "Harvard Avenue", "Packards Corner", "Babcock Street", "Pleasant Street", "Saint Paul Street", "Boston University West", "Boston University Central", "Boston University East", "Blandford Street", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street"]
    
    let cStations = ["Cleveland Circle", "Englewood Avenue", "Dean Road", "Tappan Street", "Washington Square", "Fairbanks Street", "Brandon Hall", "Summit Avenue", "Coolidge Corner", "Saint Paul Street", "Kent Street", "Hawes Street", "Saint Marys Street", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street", "Government Center", "Haymarket", "North Station"]
    
    let dStations = ["Riverside", "Woodland", "Waban", "Eliot", "Newton Highlands", "Newton Centre", "Chestnut Hill", "Reservoir", "Beaconsfield", "Brookline Hills", "Brookline Village", "Longwood", "Fenway", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street", "Government Center"]
    
    let eStations = ["Heath Street", "Back of the Hill", "Riverway", "Mission Park", "Fenwood Road", "Brigham Circle", "Longwood Medical Area", "Museum of Fine Arts", "Northeastern University", "Symphony", "Prudential", "Copley", "Arlington", "Boylston", "Park Street", "Government Center", "Haymarket", "North Station", "Science Park", "Lechmere"]
    
    let stationsByNumber = ["70179": "Brookline Hills", "70252": "Fenwood Road", "70182": "Longwood", "70157": "Arlington", "70216": "Kent Street", "70144": "Boston University Central", "70120": "Washington Street", "70149": "Blandford Street", "70167": "Eliot", "1372": "Coolidge Corner", "70181": "Brookline Village", "1308": "Coolidge Corner", "70165": "Waban", "70177": "Beaconsfield", "70143": "Boston University West", "70173": "Chestnut Hill", "70215": "Kent Street", "70223": "Summit Avenue", "70124": "Warren Street", "70207": "Science Park", "70178": "Brookline Hills", "70248": "Longwood Medical Area", "70024": "Haymarket", "70140": "Saint Paul Street", "70166": "Eliot", "70151": "Kenmore", "70114": "Chiswick Road", "70235": "Englewood Avenue", "1292": "Washington Square", "70186": "Fenway", "70174": "Reservoir", "6574": "Heath Street", "41391": "Northeastern University", "70170": "Newton Centre", "70243": "Northeastern University", "70159": "Boylston", "70171": "Newton Centre", "70154": "Copley", "1807": "Fenway", "70160": "Riverside", "70145": "Boston University Central", "70142": "Boston University West", "70163": "Woodland", "70227": "Fairbanks Street", "70106": "Boston College", "70111": "South Street", "70137": "Babcock Street", "70253": "Mission Park", "70169": "Newton Highlands", "70148": "Blandford Street", "70117": "Sutherland Road", "70236": "Englewood Avenue", "70126": "Allston Street", "114": "North Station", "1761": "Heath Street", "38155": "Riverside", "70125": "Warren Street", "70138": "Pleasant Street", "70155": "Copley", "70130": "Harvard Avenue", "70164": "Waban", "70156": "Arlington", "70224": "Summit Avenue", "70251": "Fenwood Road", "70136": "Babcock Street", "70217": "Saint Paul Street", "70233": "Dean Road", "70214": "Hawes Street", "70213": "Hawes Street", "70209": "Lechmere", "70152": "Hynes Convention Center", "70153": "Hynes Convention Center", "70228": "Fairbanks Street", "4510": "Government Center", "70249": "Brigham Circle", "70162": "Woodland", "70176": "Beaconsfield", "70225": "Brandon Hall", "70115": "Chiswick Road", "70212": "Saint Marys Street", "70218": "Saint Paul Street", "70180": "Brookline Village", "70146": "Boston University East", "70147": "Boston University East", "70211": "Saint Marys Street", "70257": "Back of the Hill", "70139": "Pleasant Street", "70241": "Symphony", "70239": "Prudential", "70127": "Allston Street", "70226": "Brandon Hall", "70250": "Brigham Circle", "70116": "Sutherland Road", "70255": "Riverway", "21917": "Reservoir", "70240": "Prudential", "70258": "Back of the Hill", "70168": "Newton Highlands", "70025": "Haymarket", "70234": "Dean Road", "70128": "Griggs Street", "70112": "Chestnut Hill Avenue", "70237": "Cleveland Circle", "70254": "Mission Park", "70158": "Boylston", "70039": "Government Center", "70208": "Science Park", "70110": "South Street", "14150": "Lechmere", "70150": "Kenmore", "70141": "Saint Paul Street", "113": "North Station", "70135": "Packards Corner", "70245": "Museum of Fine Arts", "70107": "Boston College", "70231": "Tappan Street", "70076": "Park Street", "70113": "Chestnut Hill Avenue", "70246": "Museum of Fine Arts", "70131": "Harvard Avenue", "70134": "Packards Corner", "70172": "Chestnut Hill", "70183": "Longwood", "70256": "Riverway", "70075": "Park Street", "1276": "Washington Square", "70242": "Symphony", "70247": "Longwood Medical Area", "70121": "Washington Street", "70238": "Cleveland Circle", "70129": "Griggs Street", "70232": "Tappan Street"]
    
    let stations = ["Waban": Station(name: "Waban", id: "place-waban", platformID1: "70164", platformID2: "70165"), "Washington Square": Station(name: "Washington Square", id: "place-bcnwa", platformID1: "1276", platformID2: "1292"), "Riverside": Station(name: "Riverside", id: "place-river", platformID1: "38155", platformID2: "70160"), "Packards Corner": Station(name: "Packards Corner", id: "place-brico", platformID1: "70134", platformID2: "70135"), "Cleveland Circle": Station(name: "Cleveland Circle", id: "place-clmnl", platformID1: "70237", platformID2: "70238"), "Brandon Hall": Station(name: "Brandon Hall", id: "place-bndhl", platformID1: "70225", platformID2: "70226"), "North Station": Station(name: "North Station", id: "place-north", platformID1: "113", platformID2: "114"), "Hynes Convention Center": Station(name: "Hynes Convention Center", id: "place-hymnl", platformID1: "70152", platformID2: "70153"), "Science Park": Station(name: "Science Park", id: "place-spmnl", platformID1: "70207", platformID2: "70208"), "Park Street": Station(name: "Park Street", id: "place-pktrm", platformID1: "70075", platformID2: "70076"), "Sutherland Road": Station(name: "Sutherland Road", id: "place-sthld", platformID1: "70116", platformID2: "70117"), "Copley": Station(name: "Copley", id: "place-coecl", platformID1: "70154", platformID2: "70155"), "South Street": Station(name: "South Street", id: "place-sougr", platformID1: "70110", platformID2: "70111"), "Eliot": Station(name: "Eliot", id: "place-eliot", platformID1: "70166", platformID2: "70167"), "Arlington": Station(name: "Arlington", id: "place-armnl", platformID1: "70156", platformID2: "70157"), "Tappan Street": Station(name: "Tappan Street", id: "place-tapst", platformID1: "70231", platformID2: "70232"), "Riverway": Station(name: "Riverway", id: "place-rvrwy", platformID1: "70255", platformID2: "70256"), "Beaconsfield": Station(name: "Beaconsfield", id: "place-bcnfd", platformID1: "70176", platformID2: "70177"), "Warren Street": Station(name: "Warren Street", id: "place-wrnst", platformID1: "70124", platformID2: "70125"), "Brookline Hills": Station(name: "Brookline Hills", id: "place-brkhl", platformID1: "70178", platformID2: "70179"), "Washington Street": Station(name: "Washington Street", id: "place-wascm", platformID1: "70120", platformID2: "70121"), "Northeastern University": Station(name: "Northeastern University", id: "place-nuniv", platformID1: "41391", platformID2: "70243"), "Griggs Street": Station(name: "Griggs Street", id: "place-grigg", platformID1: "70128", platformID2: "70129"), "Dean Road": Station(name: "Dean Road", id: "place-denrd", platformID1: "70233", platformID2: "70234"), "Haymarket": Station(name: "Haymarket", id: "place-haecl", platformID1: "70024", platformID2: "70025"), "Reservoir": Station(name: "Reservoir", id: "place-rsmnl", platformID1: "21917", platformID2: "70174"), "Chestnut Hill Avenue": Station(name: "Chestnut Hill Avenue", id: "place-chill", platformID1: "70112", platformID2: "70113"), "Boston University East": Station(name: "Boston University East", id: "place-buest", platformID1: "70146", platformID2: "70147"), "Summit Avenue": Station(name: "Summit Avenue", id: "place-sumav", platformID1: "70223", platformID2: "70224"), "Allston Street": Station(name: "Allston Street", id: "place-alsgr", platformID1: "70126", platformID2: "70127"), "Chiswick Road": Station(name: "Chiswick Road", id: "place-chswk", platformID1: "70114", platformID2: "70115"), "Boston University Central": Station(name: "Boston University Central", id: "place-bucen", platformID1: "70144", platformID2: "70145"), "Boston College": Station(name: "Boston College", id: "place-lake", platformID1: "70106", platformID2: "70107"), "Saint Marys Street": Station(name: "Saint Marys Street", id: "place-smary", platformID1: "70211", platformID2: "70212"), "Kenmore": Station(name: "Kenmore", id: "place-kencl", platformID1: "70150", platformID2: "70151"), "Heath Street": Station(name: "Heath Street", id: "place-hsmnl", platformID1: "1761", platformID2: "6574"), "Mission Park": Station(name: "Mission Park", id: "place-mispk", platformID1: "70253", platformID2: "70254"), "Fairbanks Street": Station(name: "Fairbanks Street", id: "place-fbkst", platformID1: "70227", platformID2: "70228"), "Hawes Street": Station(name: "Hawes Street", id: "place-hwsst", platformID1: "70213", platformID2: "70214"), "Back of the Hill": Station(name: "Back of the Hill", id: "place-bckhl", platformID1: "70257", platformID2: "70258"), "Harvard Avenue": Station(name: "Harvard Avenue", id: "place-harvd", platformID1: "70130", platformID2: "70131"), "Boston University West": Station(name: "Boston University West", id: "place-buwst", platformID1: "70142", platformID2: "70143"), "Saint Paul Street": Station(name: "Saint Paul Street", id: "place-stpul", platformID1: "70217", platformID2: "70218"), "Brookline Village": Station(name: "Brookline Village", id: "place-bvmnl", platformID1: "70180", platformID2: "70181"), "Brigham Circle": Station(name: "Brigham Circle", id: "place-brmnl", platformID1: "70249", platformID2: "70250"), "Englewood Avenue": Station(name: "Englewood Avenue", id: "place-engav", platformID1: "70235", platformID2: "70236"), "Coolidge Corner": Station(name: "Coolidge Corner", id: "place-cool", platformID1: "1308", platformID2: "1372"), "Lechmere": Station(name: "Lechmere", id: "place-lech", platformID1: "14150", platformID2: "70209"), "Blandford Street": Station(name: "Blandford Street", id: "place-bland", platformID1: "70148", platformID2: "70149"), "Longwood": Station(name: "Longwood", id: "place-longw", platformID1: "70182", platformID2: "70183"), "Chestnut Hill": Station(name: "Chestnut Hill", id: "place-chhil", platformID1: "70172", platformID2: "70173"), "Symphony": Station(name: "Symphony", id: "place-symcl", platformID1: "70241", platformID2: "70242"), "Fenwood Road": Station(name: "Fenwood Road", id: "place-fenwd", platformID1: "70251", platformID2: "70252"), "Kent Street": Station(name: "Kent Street", id: "place-kntst", platformID1: "70215", platformID2: "70216"), "Prudential": Station(name: "Prudential", id: "place-prmnl", platformID1: "70239", platformID2: "70240"), "Longwood Medical Area": Station(name: "Longwood Medical Area", id: "place-lngmd", platformID1: "70247", platformID2: "70248"), "Woodland": Station(name: "Woodland", id: "place-woodl", platformID1: "70162", platformID2: "70163"), "Pleasant Street": Station(name: "Pleasant Street", id: "place-plsgr", platformID1: "70138", platformID2: "70139"), "Fenway": Station(name: "Fenway", id: "place-fenwy", platformID1: "1807", platformID2: "70186"), "Museum of Fine Arts": Station(name: "Museum of Fine Arts", id: "place-mfa", platformID1: "70245", platformID2: "70246"), "Newton Centre": Station(name: "Newton Centre", id: "place-newto", platformID1: "70170", platformID2: "70171"), "Government Center": Station(name: "Government Center", id: "place-gover", platformID1: "4510", platformID2: "70039"), "Babcock Street": Station(name: "Babcock Street", id: "place-babck", platformID1: "70136", platformID2: "70137"), "Boylston": Station(name: "Boylston", id: "place-boyls", platformID1: "70158", platformID2: "70159"), "Newton Highlands": Station(name: "Newton Highlands", id: "place-newtn", platformID1: "70168", platformID2: "70169")]
    
}



struct RawServerResponseStations : Decodable {
    
    struct Data: Decodable {
        var attributes: Attributes
        var id: String
        var relationships: Relationships
    }
    
    struct Attributes: Decodable {
        var name: String
    }
    
    struct Relationships: Decodable {
        var child_stops: DataWithNameID
    }
    
    struct DataWithNameID: Decodable {
        var data: [DataWithNameID2]
    }
    
    struct DataWithNameID2: Decodable {
        var id: String
        var type: String
    }
    
    var data: [Data]
}

struct SeparatedServerResponseStations : Decodable {
    var stations = [String : Station]()
    var stations2 = [String : String]()
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStations(from: decoder)
        
        for d in rawResponse.data {
            stations[d.attributes.name] = Station(name: d.attributes.name, id: d.id, platformID1: d.relationships.child_stops.data[0].id, platformID2: d.relationships.child_stops.data[1].id)
            stations2[d.relationships.child_stops.data[0].id] = d.attributes.name
            stations2[d.relationships.child_stops.data[1].id] = d.attributes.name
//            stations.append(Station(name: d.attributes.name, id: d.id, platformID1: d.relationships.child_stops.data[0].id, platformID2: d.relationships.child_stops.data[1].id))
        }
    }
}

struct StationListingServerResponse : Decodable {
    var stations = [String]()
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStations(from: decoder)
        
        for d in rawResponse.data {
            stations.append(d.attributes.name)
        }
//        stations.reverse()
    }
}
