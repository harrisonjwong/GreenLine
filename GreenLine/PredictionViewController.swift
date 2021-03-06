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
        let footer = UIView()
        footer.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = footer
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.outboundTrains.count
        } else {
            return store.inboundTrains.count
        }
        return store.allTrains.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePredictionCell", for: indexPath) as! SinglePredictionCell
        
        
        var prediction: Train
        if indexPath.section == 0 {
            prediction = store.outboundTrains[indexPath.row]
        } else {
            prediction = store.inboundTrains[indexPath.row]
        }
        
        cell.destinationLabel.text = prediction.headsign
        
        cell.predictionLabel.text = "\(getTimeInMinSec(prediction.arrivalTime, prediction.departureTime) ?? "Unavailable") (next: \(prediction.nextStop ?? "Unavailable"))"
//        cell.predictionLabel.text = "(next: \(prediction.nextStop ?? "Unavailable"))"
//
//        cell.minutesLabel.text = "\(getTimeInMinSec(prediction.arrivalTime, prediction.departureTime) ?? "Unavailable")"
        
        cell.numbersLabel.text = prediction.carNumbers
        if let stops = prediction.stopsAway {
            if prediction.carNumbers == nil {
                cell.numbersLabel.text = stops
            } else {
                cell.numbersLabel.text?.append(" - ")
                cell.numbersLabel.text?.append(stops)
            }
        }
        addLineImage(cell.lineImage, route: prediction.route, direction: prediction.direction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Outbound"
        } else {
            return "Inbound"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "OpenSans-Bold", size: 16.0)
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
