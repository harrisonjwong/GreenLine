//
//  FirstViewController.swift
//  GreenLine
//
//  Created by Harrison Wong on 8/17/2018.
//  Copyright © 2018 Harrison Wong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var store = GLStore()
//    var constants = Constants()
//    var stationStore = StationStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store.fetchData(station: "place-gover")
//        stationStore.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

