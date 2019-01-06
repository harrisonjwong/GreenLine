//
//  LineViewController.swift
//  GreenLine
//
//  Created by Benjamin Chan on 1/5/19.
//  Copyright © 2019 Harrison Wong. All rights reserved.
//

import Foundation
import UIKit

class LineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = 100.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset.left = 10.0
        tableView.separatorInset.right = 10.0
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        header.backgroundColor = UIColor.gray
        let leftInset = UIView(frame: CGRect(x: 0, y: 0, width: tableView.separatorInset.left, height: 1))
        let rightInset = UIView(frame: CGRect(x: (tableView.frame.size.width - tableView.separatorInset.right), y: 0, width: tableView.separatorInset.right, height: 1))
        header.addSubview(leftInset)
        header.addSubview(rightInset)
        leftInset.backgroundColor = UIColor.darkGray
        rightInset.backgroundColor = UIColor.darkGray
        tableView.tableHeaderView = header
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineCell", for: indexPath) as! LineCell
        switch indexPath.row {
        case 0:
            cell.lineImage.image = #imageLiteral(resourceName: "Green Line B")
            cell.lineName.text = "B Line"
        case 1:
            cell.lineImage.image = #imageLiteral(resourceName: "Green Line C")
            cell.lineName.text = "C Line"
        case 2:
            cell.lineImage.image = #imageLiteral(resourceName: "Green Line D")
            cell.lineName.text = "D Line"
        case 3:
            cell.lineImage.image = #imageLiteral(resourceName: "Green Line E")
            cell.lineName.text = "E Line"
        default:
            cell.lineImage.image = #imageLiteral(resourceName: "Green Line")
            cell.lineName.text = "Unknown Line"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showStations", sender: "b")
        case 1:
            performSegue(withIdentifier: "showStations", sender: "c")
        case 2:
            performSegue(withIdentifier: "showStations", sender: "d")
        case 3:
            performSegue(withIdentifier: "showStations", sender: "e")
        default:
            performSegue(withIdentifier: "showStations", sender: "other")
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStations" {
            let line = sender as! String
            let listViewController = segue.destination as! ListViewController
            let stationStore = StationStore()
            listViewController.flag = true
            switch line {
            case "b":
                listViewController.setStationList(stationStore.bStations)
            case "c":
                listViewController.setStationList(stationStore.cStations)
            case "d":
                listViewController.setStationList(stationStore.dStations)
            case "e":
                listViewController.setStationList(stationStore.eStations)
            default:
                break
            }
        }
    }
    
    
}
