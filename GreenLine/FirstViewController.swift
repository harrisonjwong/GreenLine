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
        if prediction.arrivalTime == nil {
            cell.predictionLabel.text = "\(prediction.arrivalTime) (next stop: \(prediction.nextStop))"
        } else {
            cell.predictionLabel.text = "\(prediction.stopsAway) (next stop: \(prediction.nextStop))"
        }

        cell.numbersLabel.text = prediction.carNumbers
        addLineImage(cell.lineLabel, route: prediction.route, direction: prediction.direction)
        
        return cell
    }
    
    func addLineImage(_ label: UILabel, route: String, direction: Int) {
        let attachment = NSTextAttachment()
        if direction == 1 {
            attachment.image = UIImage(named: "Green Line.png")
        } else {
            switch route {
            case "Green-B":
                attachment.image = UIImage(named: "Green Line B.png")
            case "Green-C":
                attachment.image = UIImage(named: "Green Line C.png")
            case "Green-D":
                attachment.image = UIImage(named: "Green Line D.png")
            case "Green-E":
                attachment.image = UIImage(named: "Green Line E.png")
            default:
                attachment.image = UIImage(named: "Green Line.png")
            }
        }
        attachment.image = UIImage(named: "Green Line.png")
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        label.attributedText = myString
    }
    
}
