//
//  FirstViewController.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var store: GLStore!
    //    var constants = Constants()
    var stationStore = StationStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view, typically from a nib.
//        store.fetchData(station: "place-pktrm")
//        stationStore.fetchStationList()
//        stationStore.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        store.fetchData(station: "place-pktrm")
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
        print(prediction)
        print("here?")
        
        cell.destinationLabel.text = prediction.headsign
        if prediction.arrivalTime != nil {
            cell.predictionLabel.text = "\(getTimeInMinSec(prediction.arrivalTime)!) (next stop: \(prediction.nextStop ?? ""))"
        } else {
            cell.predictionLabel.text = "\(prediction.stopsAway) (next stop: \(prediction.nextStop))"
        }

        cell.numbersLabel.text = prediction.carNumbers
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
    
    
    func getTimeInMinSec(_ d: Date?)-> String? {
        if d != nil {
            let min = round(d!.timeIntervalSinceNow/60)
            let min2 = Int(min)
            let sec = round(d!.timeIntervalSinceNow.truncatingRemainder(dividingBy: 60))
            return "\(min2) min"
        }
        return nil
    }
    
}
