//
//  DetailVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/15/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

protocol DetailVCDelegate {
    func deselectAll()
}

class DetailVC: UIViewController {
    
    var delegate : DetailVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
    }
    
    @objc func close() {
        self.delegate?.deselectAll()
        self.dismiss(animated: true, completion: nil)
    }

}
