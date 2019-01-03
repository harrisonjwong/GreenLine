//
//  SecondViewController.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //FIX ME THIS CODE IS SO BAD AHHHHH
    var stations: [String] {
        let stationStore = StationStore()
        var temp = [String]()
        temp.append(contentsOf: stationStore.bStations)
        temp.append(contentsOf: stationStore.cStations)
        temp.append(contentsOf: stationStore.dStations)
        temp.append(contentsOf: stationStore.eStations)
        return temp
    }

    let stationDict = StationStore().stationInfo
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let stationName = stations[indexPath.row]
        
        cell.textLabel?.text = stationName
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stationName = stations[indexPath.row]
        let stationObj = stationDict[stationName]
        if let stationCode = stationObj?.id {
            let glStore = GLStore()
            let handler: (Bool) -> Bool = { done in
                if done {
                    return true
                } else {
                    return false
                }
            }
            DispatchQueue.global().async {
                glStore.fetchData(station: stationCode, enterBlock: handler)
                DispatchQueue.main.async {
                    while glStore.allTrains.isEmpty && !glStore.finishedLoading {
                        // Wait
                    }
                    self.performSegue(withIdentifier: "showPrediction", sender: glStore)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPrediction" {
            let store = sender as! GLStore
            let firstViewController = segue.destination as! FirstViewController
            firstViewController.store = store
            
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if sender != nil {
//                let cell = sender as! UITableViewCell
//                let indexPath = self.tableView.indexPath(for: cell)
//                let event = eventStore.allEvents[indexPath!.row]
//                let editViewController = segue.destination as! DetailViewController
//                editViewController.event = event
//            } else {
//                let newItem = eventStore.createEvent()
//
//                // Figure out where that item is in the array
//                if let index = eventStore.allEvents.index(of: newItem) {
//                    let indexPath = NSIndexPath(row: index, section: 0)
//
//                    // Insert this new row into the table.
//                    tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
//                    let editViewController = segue.destination as! DetailViewController
//                    editViewController.event = newItem
//                }
//            }
//        }
//    }
}

