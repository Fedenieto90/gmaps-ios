//
//  MapCardCell.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/24/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class MapCardCell: UICollectionViewCell {
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var topCellCardView: UIView!
    
    var parentVC : UIViewController!
    
    var activeController: UIViewController? {
        didSet {
            self.replaceActiveViewController(oldVC: oldValue, newVC: activeController)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundTopCellViewCorners()
    }
    
    func roundTopCellViewCorners() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    
    private func replaceActiveViewController(oldVC: UIViewController?, newVC: UIViewController?)
    {
        if oldVC == newVC {
            return
        }
        
        if oldVC != nil {
            oldVC!.willMove(toParentViewController: nil)
            oldVC!.view.removeFromSuperview()
            oldVC!.removeFromParentViewController()
            NSLog("Removed %@", oldVC!)
        }
        
        if newVC != nil {
            newVC!.willMove(toParentViewController: parentVC)
            parentVC.addChildViewController(newVC!)
            newVC!.view.frame = self.cardContainerView.bounds
            self.cardContainerView.addSubview(newVC!.view)
            newVC!.didMove(toParentViewController: parentVC)
            NSLog("Added %@", newVC!)
        }
    }
    
}
