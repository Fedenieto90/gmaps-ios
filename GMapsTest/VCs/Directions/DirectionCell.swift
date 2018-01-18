//
//  DirectionCell.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/9/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class DirectionCell: UICollectionViewCell {
    
    @IBOutlet weak var busLineLbl: UILabel!
    @IBOutlet weak var busLineColor: UIView!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    let cellID = "directionCell"
    
}
