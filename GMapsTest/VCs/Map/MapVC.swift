//
//  MapVC.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/12/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import Macaw
import Pulley

class MapVC: UIViewController, PulleyPrimaryContentControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svgView: SVGView!
    
    var provinces = [Province]()
    var selectedProvince : Province?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load provinces
        loadProvinces()
        
        //Configure touch handlers for each node in the .svg file
        configureTouchHandlers()
    }
    
    func loadProvinces() {
        let buenosAires = Province(name: "Buenos Aires",
                                   id: "AR-B",
                                   cities: ["Buenos Aires", "Mar del Plata"])
        let cordoba = Province(name: "Córdoba",
                               id: "AR-X",
                               cities: ["Río Cuarto", "Rio Tercero"])
        self.provinces.append(buenosAires)
        self.provinces.append(cordoba)
    }
        
    func selectProvince(nodeTag : String) {
        let provinceShape = self.svgView.node.nodeBy(tag: nodeTag) as! Shape
         provinceShape.fill = Color.red
    }
    
    func deselectProvince(nodeTag: String) {
        let provinceShape = self.svgView.node.nodeBy(tag: nodeTag) as! Shape
        provinceShape.fill = Color.rgba(r: Int(204.0), g: Int(204.0), b: Int(204.0), a: 1)
    }
    
    func provinceSelected(tag : String) -> Province? {
        if let itemSelected = provinces.first(where: {$0.id == tag}) {
            return itemSelected
        }
        return nil
    }
    
    func configureTouchHandlers() {
        
        for province in provinces {
            svgView.node.nodeBy(tag: province.id)?.onTouchPressed({ (touch) in
                
                //Print selected province tag
                print(province.id)
                
                //Select province
                self.selectProvince(nodeTag: province.id)
                
                //If there is a province selected and we tap on another, we must deselect the already selected one
                if self.selectedProvince != nil &&
                    self.provinceSelected(tag: province.id)?.id != self.selectedProvince?.id {
                    self.deselect(province: self.selectedProvince!)
                }
                
                //We select the tapped province and update the cities bottom sheet
                if let provinceSelected = self.provinceSelected(tag: province.id) {
                    
                    //Save the selected province
                    self.selectedProvince = provinceSelected
                    
                    //Notify the bottom sheet that a new province was selected
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProvinceTapped"), object: nil, userInfo: ["province" : provinceSelected])
                    
                    //Set cities table view to partially revealed
                    (self.parent as! PulleyViewController).setDrawerPosition(position: PulleyPosition.partiallyRevealed, animated: true)
                }
            })
        }
    }
    
    func deselect(province : Province) {
        if let provinceShape = self.svgView.node.nodeBy(tag: province.id) as? Shape {
            self.deselectProvince(nodeTag: provinceShape.tag.first!)
        }
    }
    
    //MARK : - PulleyPrimaryContentControllerDelegate
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition == .partiallyRevealed {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 200.0, 0.0)
        } else if drawer.drawerPosition == .collapsed {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0)
        }
    }

}
