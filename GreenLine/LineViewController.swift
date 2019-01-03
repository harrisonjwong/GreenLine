//
//  LineViewController.swift
//  GreenLine
//
//  Created by Benjamin Chan on 1/3/19.
//  Copyright © 2019 Harrison Wong. All rights reserved.
//

import Foundation
import UIKit

class LineViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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


    
    
}
