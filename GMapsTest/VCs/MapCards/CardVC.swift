//
//  CardVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/24/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class CardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var provinceLbl: UILabel!
    var province : Province!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.provinceLbl.text = province.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return province.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = province.cities[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }

}
