//
//  MapCardsVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/24/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class MapCardsVC: UIViewController {
    
    @IBOutlet weak var cardCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pannableView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var originalPosition: CGPoint!
    var currentPositionTouched: CGPoint!
    var halfScreen : CGFloat!
    
    var provinces = [Province]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionViewHeightConstraint.constant = self.view.bounds.size.height
        addPanGesture()
        
        provinces = ProvincesHelper.provinces()
    }
    
    func addPanGesture() {
        //Add pan gesture to collection view
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        pannableView.addGestureRecognizer(panGestureRecognizer)
        halfScreen = self.view.bounds.size.height / 2
    }
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        if panGesture.state == .began {
            if originalPosition == nil {
             originalPosition = pannableView.center
            }
            currentPositionTouched = pannableView.center
        } else if panGesture.state == .changed {
           pannableView.center = CGPoint(x: currentPositionTouched.x, y: currentPositionTouched.y + translation.y)
            collectionView.frame.origin = CGPoint(x: 0, y: currentPositionTouched.y + translation.y)
        } else if panGesture.state == .ended {
            let panGestureLocation = panGesture.location(in: self.view.window).y
            let velocity = panGesture.velocity(in: self.view)
            if ((panGestureLocation < halfScreen && velocity.y >= 0) || velocity.y > 0) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.pannableView.center = CGPoint(x: self.originalPosition.x, y: self.originalPosition.y)
                    self.collectionView.frame.origin = CGPoint(x: 0, y: self.originalPosition.y)
                }, completion: { (isCompleted) in
                    if isCompleted {
                    
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.pannableView.center =  CGPoint(x: self.originalPosition.x, y: self.view.frame.origin.y + 100)
                     self.collectionView.frame.origin = CGPoint(x: 0, y: self.view.frame.origin.y + 100)
                })
            }
        }
    }
}

extension MapCardsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCardCell", for: indexPath) as! MapCardCell
        //Instantiate
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cardInfoVC") as! CardVC
        let nav = UINavigationController(rootViewController: vc)
        vc.province = provinces[indexPath.row]
        cell.parentVC = self
        nav.navigationBar.barTintColor = UIColor.white
        cell.activeController = nav
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProvincesHelper.provinces().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
}
