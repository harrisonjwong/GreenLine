//
//  FirstViewController.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import UIKit

class PredictionViewController: UITableViewController {
    
    var store: GLStore!
    //    var constants = Constants()
    var stationStore = StationStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refreshGLStore), for: .valueChanged)
        
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
//        store.fetchData(station: "place-pktrm")
//        stationStore.fetchStationList()
//        stationStore.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        store.fetchData(station: "place-pktrm")
        
        //THIS CODE IS SO BAD WHAT AM I DOING AHHHHHH
        var temp = [String : String]()
        for item in stationStore.stationInfo {
            temp[item.value.id] = item.key
        }
        navigationItem.title = temp[store.station]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.allTrains.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePredictionCell", for: indexPath) as! SinglePredictionCell
        
        let prediction = store.allTrains[indexPath.row]
        
        cell.destinationLabel.text = prediction.headsign
        
        cell.predictionLabel.text = "\(getTimeInMinSec(prediction.arrivalTime, prediction.departureTime) ?? "Unavailable") (next: \(prediction.nextStop ?? "Unavailable"))"

        cell.numbersLabel.text = prediction.carNumbers
        if let stops = prediction.stopsAway {
            cell.numbersLabel.text?.append(" - ")
            cell.numbersLabel.text?.append(stops)
        }
        addLineImage(cell.lineImage, route: prediction.route, direction: prediction.direction)
        return cell
    }
    
    func addLineImage(_ imageView: UIImageView, route: String, direction: Int) {
        if direction == 1 {
            imageView.image = #imageLiteral(resourceName: "Green Line")
        } else {
            switch route {
            case "Green-B":
                imageView.image = #imageLiteral(resourceName: "Green Line B")
            case "Green-C":
                imageView.image = #imageLiteral(resourceName: "Green Line C")
            case "Green-D":
                imageView.image = #imageLiteral(resourceName: "Green Line D")
            case "Green-E":
                imageView.image = #imageLiteral(resourceName: "Green Line E")
            default:
                imageView.image = #imageLiteral(resourceName: "Green Line")
            }
        }
    }
    

    func getTimeInMinSec(_ d: Date?, _ d2: Date?)-> String? {
        if d != nil {
            let min = round(d!.timeIntervalSinceNow/60)
            let min2 = Int(min)
//            let sec = round(d!.timeIntervalSinceNow.truncatingRemainder(dividingBy: 60))
            if min2 == 0 {
                return "ARR"
            } else if d2 != nil {
                let min3 = round(d2!.timeIntervalSinceNow/60)
                if min3 <= 0 {
                    return "BRD"
                }
            }
            return "\(min2) min"
        } else if let departTime = d2 {
            let min4 = round(departTime.timeIntervalSinceNow/60)
            return "\(Int(min4)) min"
        }
        return nil
    }
    
    let handler: (Bool) -> Bool = { done in
        if done {
            return true
        } else {
            return false
        }
    }
    
    @objc private func refreshGLStore() {
        DispatchQueue.global().async {
            self.store.allTrains.removeAll()
            self.store.fetchData(station: self.store.station, enterBlock: self.handler)
            DispatchQueue.main.async {
                while self.store.allTrains.isEmpty && !self.store.finishedLoading {
                    // Wait
                }
                self.store.allTrains.sort()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            
        }
        
    }
    
}
