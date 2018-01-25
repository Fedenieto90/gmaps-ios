//
//  MapCardCell.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/24/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class MapCardCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    
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
        // border
        self.layer.cornerRadius = 8
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        self.cardContainerView.layer.masksToBounds = true
    }
    
    
    //MARK: - Active ViewController Handling
    
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
