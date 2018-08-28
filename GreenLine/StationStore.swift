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
    
    var fullStationIDs = [String]()
    var stations = [Station]()
    
    func fetchData() {
        let urlAsURL = URL(string: url)
        let request = URLRequest(url: urlAsURL!)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(SeparatedServerResponseStations.self, from: jsonData)
                    self.stations = stuff.stations
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
    
    func fetchStationList() {
        let urlAsURL = URL(string: "https://api-v3.mbta.com/stops?api_key=eb4cde2daae74dcfbbf324987283b2d4&filter[route_type]=0")
        let request = URLRequest(url: urlAsURL!)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let stuff = try decoder.decode(SeparatedServerResponseFullStations.self, from: jsonData)
                    self.fullStationIDs = stuff.stations
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
    
    let stationInfo = ["Boston College" : Station(name: "Boston College", id: "place-lake", platforms: ["70106", "70107"]), "South Street" : Station(name: "South Street", id: "place-sougr", platforms: ["70110", "70111"]), "Chestnut Hill Avenue" : Station(name: "Chestnut Hill Avenue", id: "place-chill", platforms: ["70112", "70113"]), "Chiswick Road" : Station(name: "Chiswick Road", id: "place-chswk", platforms: ["70114", "70115"]), "Sutherland Road" : Station(name: "Sutherland Road", id: "place-sthld", platforms: ["70116", "70117"]), "Washington Street" : Station(name: "Washington Street", id: "place-wascm", platforms: ["70120", "70121"]), "Warren Street" : Station(name: "Warren Street", id: "place-wrnst", platforms: ["70124", "70125"]), "Allston Street" : Station(name: "Allston Street", id: "place-alsgr", platforms: ["70126", "70127"]), "Griggs Street" : Station(name: "Griggs Street", id: "place-grigg", platforms: ["70128", "70129"]), "Harvard Avenue" : Station(name: "Harvard Avenue", id: "place-harvd", platforms: ["70130", "70131"]), "Packards Corner" : Station(name: "Packards Corner", id: "place-brico", platforms: ["70134", "70135"]), "Babcock Street" : Station(name: "Babcock Street", id: "place-babck", platforms: ["70136", "70137"]), "Pleasant Street" : Station(name: "Pleasant Street", id: "place-plsgr", platforms: ["70138", "70139"]), "Saint Paul Street-B" : Station(name: "Saint Paul Street", id: "place-stplb", platforms: ["70140", "70141"]), "Boston University West" : Station(name: "Boston University West", id: "place-buwst", platforms: ["70142", "70143"]), "Boston University Central" : Station(name: "Boston University Central", id: "place-bucen", platforms: ["70144", "70145"]), "Boston University East" : Station(name: "Boston University East", id: "place-buest", platforms: ["70146", "70147"]), "Blandford Street" : Station(name: "Blandford Street", id: "place-bland", platforms: ["70148", "70149"]), "Cleveland Circle" : Station(name: "Cleveland Circle", id: "place-clmnl", platforms: ["70237", "70238"]), "Englewood Avenue" : Station(name: "Englewood Avenue", id: "place-engav", platforms: ["70235", "70236"]), "Dean Road" : Station(name: "Dean Road", id: "place-denrd", platforms: ["70233", "70234"]), "Tappan Street" : Station(name: "Tappan Street", id: "place-tapst", platforms: ["70231", "70232"]), "Washington Square" : Station(name: "Washington Square", id: "place-bcnwa", platforms: ["70229", "70230"]), "Fairbanks Street" : Station(name: "Fairbanks Street", id: "place-fbkst", platforms: ["70227", "70228"]), "Brandon Hall" : Station(name: "Brandon Hall", id: "place-bndhl", platforms: ["70225", "70226"]), "Summit Avenue" : Station(name: "Summit Avenue", id: "place-sumav", platforms: ["70223", "70224"]), "Coolidge Corner" : Station(name: "Coolidge Corner", id: "place-cool", platforms: ["70219", "70220"]), "Saint Paul Street-C" : Station(name: "Saint Paul Street", id: "place-stpul", platforms: ["70217", "70218"]), "Kent Street" : Station(name: "Kent Street", id: "place-kntst", platforms: ["70215", "70216"]), "Hawes Street" : Station(name: "Hawes Street", id: "place-hwsst", platforms: ["70213", "70214"]), "Saint Marys Street" : Station(name: "Saint Marys Street", id: "place-smary", platforms: ["70211", "70212"]), "Riverside" : Station(name: "Riverside", id: "place-river", platforms: ["70160", "70161"]), "Woodland" : Station(name: "Woodland", id: "place-woodl", platforms: ["70162", "70163"]), "Waban" : Station(name: "Waban", id: "place-waban", platforms: ["70164", "70165"]), "Eliot" : Station(name: "Eliot", id: "place-eliot", platforms: ["70166", "70167"]), "Newton Highlands" : Station(name: "Newton Highlands", id: "place-newtn", platforms: ["70168", "70169"]), "Newton Centre" : Station(name: "Newton Centre", id: "place-newto", platforms: ["70170", "70171"]), "Chestnut Hill" : Station(name: "Chestnut Hill", id: "place-chhil", platforms: ["70172", "70173"]), "Reservoir" : Station(name: "Reservoir", id: "place-rsmnl", platforms: ["70174", "70175"]), "Beaconsfield" : Station(name: "Beaconsfield", id: "place-bcnfd", platforms: ["70176", "70177"]), "Brookline Hills" : Station(name: "Brookline Hills", id: "place-brkhl", platforms: ["70178", "70179"]), "Brookline Village" : Station(name: "Brookline Village", id: "place-bvmnl", platforms: ["70180", "70181"]), "Longwood" : Station(name: "Longwood", id: "place-longw", platforms: ["70182", "70183"]), "Fenway" : Station(name: "Fenway", id: "place-fenwy", platforms: ["70186", "70187"]), "Kenmore" : Station(name: "Kenmore", id: "place-kencl", platforms: ["70150", "70151"]), "Hynes Convention Center" : Station(name: "Hynes Convention Center", id: "place-hymnl", platforms: ["70152", "70153"]), "Heath Street" : Station(name: "Heath Street", id: "place-hsmnl", platforms: ["70260"]), "Back of the Hill" : Station(name: "Back of the Hill", id: "place-bckhl", platforms: ["70257", "70258"]), "Riverway" : Station(name: "Riverway", id: "place-rvrwy", platforms: ["70255", "70256"]), "Mission Park" : Station(name: "Mission Park", id: "place-mispk", platforms: ["70253", "70254"]), "Fenwood Road" : Station(name: "Fenwood Road", id: "place-fenwd", platforms: ["70251", "70252"]), "Brigham Circle" : Station(name: "Brigham Circle", id: "place-brmnl", platforms: ["70249", "70250"]), "Longwood Medical Area" : Station(name: "Longwood Medical Area", id: "place-lngmd", platforms: ["70247", "70248"]), "Museum of Fine Arts" : Station(name: "Museum of Fine Arts", id: "place-mfa", platforms: ["70245", "70246"]), "Northeastern University" : Station(name: "Northeastern University", id: "place-nuniv", platforms: ["70243", "70244"]), "Symphony" : Station(name: "Symphony", id: "place-symcl", platforms: ["70241", "70242"]), "Prudential" : Station(name: "Prudential", id: "place-prmnl", platforms: ["70239", "70240"]), "Copley" : Station(name: "Copley", id: "place-coecl", platforms: ["70154", "70155"]), "Arlington" : Station(name: "Arlington", id: "place-armnl", platforms: ["70156", "70157"]), "Boylston" : Station(name: "Boylston", id: "place-boyls", platforms: ["70158", "70159"]), "Park Street" : Station(name: "Park Street", id: "place-pktrm", platforms: ["70196", "70197", "70198", "70199", "70200"]), "Government Center" : Station(name: "Government Center", id: "place-gover", platforms: ["70201", "70202"]), "Haymarket" : Station(name: "Haymarket", id: "place-haecl", platforms: ["70203", "70204"]), "North Station" : Station(name: "North Station", id: "place-north", platforms: ["70205", "70206"]), "Science Park" : Station(name: "Science Park", id: "place-spmnl", platforms: ["70207", "70208"]), "Lechmere" : Station(name: "Lechmere", id: "place-lech", platforms: ["70209", "70210"])]
    
    let stationsByID = ["70179": "Brookline Hills", "70252": "Fenwood Road", "70220": "Coolidge Corner", "70182": "Longwood", "70157": "Arlington", "70216": "Kent Street", "70144": "Boston University Central", "70244": "Northeastern University", "70120": "Washington Street", "70149": "Blandford Street", "70206": "North Station", "70167": "Eliot", "70181": "Brookline Village", "70165": "Waban", "70177": "Beaconsfield", "70143": "Boston University West", "70173": "Chestnut Hill", "70205": "North Station", "70204": "Haymarket", "70215": "Kent Street", "70223": "Summit Avenue", "70124": "Warren Street", "70207": "Science Park", "70201": "Government Center", "70178": "Brookline Hills", "70248": "Longwood Medical Area", "70140": "Saint Paul Street-B", "70161": "Riverside", "70166": "Eliot", "70114": "Chiswick Road", "70151": "Kenmore", "70235": "Englewood Avenue", "70219": "Coolidge Corner", "70174": "Reservoir", "70186": "Fenway", "70170": "Newton Centre", "70200": "Park Street", "70243": "Northeastern University", "70159": "Boylston", "70210": "Lechmere", "70154": "Copley", "70171": "Newton Centre", "70160": "Riverside", "70145": "Boston University Central", "70142": "Boston University West", "70163": "Woodland", "70227": "Fairbanks Street", "70106": "Boston College", "70111": "South Street", "70137": "Babcock Street", "70253": "Mission Park", "70169": "Newton Highlands", "70197": "Park Street", "70148": "Blandford Street", "70117": "Sutherland Road", "70236": "Englewood Avenue", "70126": "Allston Street", "70125": "Warren Street", "70138": "Pleasant Street", "70175": "Reservoir", "70155": "Copley", "70130": "Harvard Avenue", "70164": "Waban", "70156": "Arlington", "70224": "Summit Avenue", "70198": "Park Street", "70251": "Fenwood Road", "70217": "Saint Paul Street-C", "70136": "Babcock Street", "70233": "Dean Road", "70214": "Hawes Street", "70213": "Hawes Street", "70209": "Lechmere", "70152": "Hynes Convention Center", "70153": "Hynes Convention Center", "70228": "Fairbanks Street", "70249": "Brigham Circle", "70162": "Woodland", "70176": "Beaconsfield", "70230": "Washington Square", "70225": "Brandon Hall", "70203": "Haymarket", "70115": "Chiswick Road", "70212": "Saint Marys Street", "70218": "Saint Paul Street-C", "70257": "Back of the Hill", "70146": "Boston University East", "70147": "Boston University East", "70211": "Saint Marys Street", "70180": "Brookline Village", "70241": "Symphony", "70139": "Pleasant Street", "70239": "Prudential", "70226": "Brandon Hall", "70127": "Allston Street", "70250": "Brigham Circle", "70116": "Sutherland Road", "70255": "Riverway", "70240": "Prudential", "70258": "Back of the Hill", "70168": "Newton Highlands", "70128": "Griggs Street", "70237": "Cleveland Circle", "70208": "Science Park", "70234": "Dean Road", "70112": "Chestnut Hill Avenue", "70254": "Mission Park", "70187": "Fenway", "70229": "Washington Square", "70110": "South Street", "70158": "Boylston", "70150": "Kenmore", "70141": "Saint Paul Street-B", "70135": "Packards Corner", "70245": "Museum of Fine Arts", "70231": "Tappan Street", "70107": "Boston College", "70113": "Chestnut Hill Avenue", "70260": "Heath Street", "70246": "Museum of Fine Arts", "70134": "Packards Corner", "70131": "Harvard Avenue", "70172": "Chestnut Hill", "70256": "Riverway", "70183": "Longwood", "70242": "Symphony", "70202": "Government Center", "70196": "Park Street", "70199": "Park Street", "70121": "Washington Street", "70238": "Cleveland Circle", "70129": "Griggs Street", "70232": "Tappan Street", "70247": "Longwood Medical Area"]
    
    let bStations = ["Boston College", "South Street", "Chestnut Hill Avenue", "Chiswick Road", "Sutherland Road", "Washington Street", "Warren Street", "Allston Street", "Griggs Street", "Harvard Avenue", "Packards Corner", "Babcock Street", "Pleasant Street", "Saint Paul Street-B", "Boston University West", "Boston University Central", "Boston University East", "Blandford Street", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street"]
    
    let cStations = ["Cleveland Circle", "Englewood Avenue", "Dean Road", "Tappan Street", "Washington Square", "Fairbanks Street", "Brandon Hall", "Summit Avenue", "Coolidge Corner", "Saint Paul Street-C", "Kent Street", "Hawes Street", "Saint Marys Street", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street", "Government Center", "Haymarket", "North Station"]
    
    let dStations = ["Riverside", "Woodland", "Waban", "Eliot", "Newton Highlands", "Newton Centre", "Chestnut Hill", "Reservoir", "Beaconsfield", "Brookline Hills", "Brookline Village", "Longwood", "Fenway", "Kenmore", "Hynes Convention Center", "Copley", "Arlington", "Boylston", "Park Street", "Government Center"]
    
    let eStations = ["Heath Street", "Back of the Hill", "Riverway", "Mission Park", "Fenwood Road", "Brigham Circle", "Longwood Medical Area", "Museum of Fine Arts", "Northeastern University", "Symphony", "Prudential", "Copley", "Arlington", "Boylston", "Park Street", "Government Center", "Haymarket", "North Station", "Science Park", "Lechmere"]
    
    var stationIDList = [String : String]()
    
    func createStationIDList() {
        for i in stationInfo {
            for x in i.value.platforms {
                stationIDList[x] = i.key
            }
        }
    }
    
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
    var stations = [Station]()
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStations(from: decoder)
        
        for d in rawResponse.data {
            stations.append(Station(name: d.attributes.name, id: d.id, platforms: d.relationships.child_stops.data.map({ $0.id }).filter({ validPlatforms.contains($0) })))
            
        }
    }
    
}

let validPlatforms = ["70238", "70197", "70240", "70160", "70111", "70258", "70154", "70252", "70202", "70199", "70204", "70128", "70146", "70115", "70260", "70155", "70177", "70228", "70158", "70213", "70141", "70257", "70157", "70232", "70131", "70164", "70211", "70152", "70210", "70251", "70127", "70245", "70183", "70196", "70156", "70229", "70226", "70247", "70167", "70121", "70239", "70114", "70142", "70110", "70170", "70173", "70126", "70117", "70242", "70140", "70203", "70153", "70216", "70165", "70135", "70159", "70149", "70230", "70244", "70172", "70186", "70198", "70139", "70254", "70148", "70130", "70212", "70175", "70223", "70233", "70143", "70150", "70182", "70106", "70112", "70187", "70217", "70147", "70168", "70237", "70180", "70138", "70162", "70134", "70144", "70231", "70243", "70250", "70255", "70161", "70181", "70201", "70246", "70169", "70179", "70256", "70166", "70207", "70200", "70236", "70218", "70137", "70145", "70113", "70129", "70225", "70234", "70136", "70224", "70241", "70178", "70209", "70124", "70151", "70248", "70116", "70219", "70235", "70176", "70215", "70205", "70253", "70171", "70208", "70107", "70163", "70220", "70206", "70174", "70120", "70214", "70125", "70249", "70227"]




struct RawServerResponseFullStations: Decodable {
    struct Data: Decodable {
        var attributes: Attributes
        var id: String
    }
    struct Attributes: Decodable {
        var description: String
    }
    
    var data: [Data]
}

struct SeparatedServerResponseFullStations: Decodable {
    var stations = [String]()
    
    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseFullStations(from: decoder)
        
        for d in rawResponse.data {
            let line = getLine(d.attributes.description)
            if line == "Green Line" {
                stations.append(d.id)
            }
        }
    }
    
    func getLine(_ description: String) -> String {
        var components = description.components(separatedBy: " - ")
        return components[1]
    }
    
}
