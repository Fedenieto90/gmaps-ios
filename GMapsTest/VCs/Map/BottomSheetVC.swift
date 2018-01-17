//
//  BottomSheetVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/15/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import Pulley

class BottomSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cities = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.provinceTapped), name: NSNotification.Name(rawValue: "ProvinceTapped"), object: nil)
    }
    
    @objc func provinceTapped(notification : Notification) {
        let province = notification.userInfo!["province"] as! Province
        self.cities = province.cities
    }
    
    //MARK : - UITableViewDelegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row] 
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

}