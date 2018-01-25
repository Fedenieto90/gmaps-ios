//
//  MapCardsVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/24/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import Macaw

class MapCardsVC: UIViewController {
    
    @IBOutlet weak var cardCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pannableView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var originalPosition: CGPoint!
    var currentPositionTouched: CGPoint!
    var halfScreen : CGFloat!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svgView: SVGView!
    
    var provinces = [Province]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionViewHeightConstraint.constant = self.view.bounds.size.height
        
        //Add cards pan gesture
        addPanGesture()
        
        //Provinces
        provinces = ProvincesHelper.provinces()
        
        //Configure touch handlers
        configureTouchHandlers()
        
        //Select first province
        selectProvince(nodeTag: provinces.first!.id)
        
        //ScrollView content insets
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
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
    
    //MARK : - Select Provinces
    
    func configureTouchHandlers() {
        for province in self.provinces {
            svgView.node.nodeBy(tag: province.id)?.onTouchPressed({ (touch) in
                //Print selected province tag
                print(province.id)
                
                //Deselect all provinces
                self.deselectAllProvinces()
                
                //Select province
                self.selectProvince(nodeTag: province.id)
            })
        }
    }
    
    func selectProvince(nodeTag : String) {
        let provinceShape = self.svgView.node.nodeBy(tag: nodeTag) as! Shape
        provinceShape.fill = Color.red
        selectProvinceCard(nodeTag: nodeTag)
    }
    
    func deselectAllProvinces() {
        for province in provinces {
            let provinceShape = self.svgView.node.nodeBy(tag: province.id) as! Shape
            provinceShape.fill = Color.rgb(r: 204, g: 204, b: 204)
        }
    }
    
    func selectProvinceCard(nodeTag : String) {
        if let i = provinces.index(where: { $0.id == nodeTag }) {
            let indexPath = IndexPath(row: i, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

}

extension MapCardsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCardCell", for: indexPath) as! MapCardCell
        
        //Instantiate View Controller for Card
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let province = provinces[(self.collectionView.indexPathsForVisibleItems.first?.row)!]
        deselectAllProvinces()
        self.selectProvince(nodeTag: province.id)
    }
    
    
}
