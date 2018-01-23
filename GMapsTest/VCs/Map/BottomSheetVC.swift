//
//  BottomSheetVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/15/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import Pulley

protocol BottomSheetVCDelegate {
    func didChangePage(province : Province)
}

class BottomSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var provinceName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var province : Province!
    var delegate : BottomSheetVCDelegate?
    var cities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.provinceName.text = province.name
        self.cities = province.cities
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.provinceTapped), name: NSNotification.Name(rawValue: "ProvinceTapped"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func provinceTapped(notification : Notification) {
        let province = notification.userInfo!["province"] as! Province
        //self.cities = province.cities
        self.delegate?.didChangePage(province : province)
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
