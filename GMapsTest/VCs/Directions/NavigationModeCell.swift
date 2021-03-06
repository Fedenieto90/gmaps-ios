//
//  NavigationModeCell.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/10/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class NavigationModeCell: UICollectionViewCell {
    
    @IBOutlet weak var navigationModeLbl: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
}
