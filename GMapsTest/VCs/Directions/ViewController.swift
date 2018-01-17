//
//  ViewController.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/9/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var flowLayout: DirectionsCollectionViewFlowLayout!
    var steps = [Step]()
    var stepPathPolylines = [GMSPolyline]()
    
    var navigationModes = [navigationMode.driving,
                           navigationMode.transit,
                           navigationMode.walking]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationModeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Configure map
        setMap()
        
        self.collectionView.reloadData()
        self.collectionView.isHidden = true
        self.navigationModeCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setMap() {
        
        // Update camera to fit start and end pois
        let startPoint = CLLocationCoordinate2D(latitude: 39.606678, longitude: 2.644017)
        let endPoint = CLLocationCoordinate2D(latitude: 39.6080321,longitude: 2.6448371)
        let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: endPoint)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: cameraUpdate)
       
        // Creates a start marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 39.5975014, longitude: 2.6405995)
        marker.title = "Son espases"
        marker.map = mapView
        
        // Creates an end marker
        let endMarker = GMSMarker()
        endMarker.position = CLLocationCoordinate2D(latitude: 39.6080321, longitude: 2.6448371)
        endMarker.title = "Café"
        endMarker.map = mapView
        
        //Set Map Style
        setMapStyle()
        
        //MapView Delegate
        mapView.delegate = self
        
    }
    
    func setMapStyle() {
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "gMapsSilverTheme", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
    }
    
    func getDirections(navMode : String) {
        DirectionsAPI.shared.getDirections(navigationMode : navMode) { (points, steps) in
            //Draw route
            self.drawRoute(points: points)
            //Store steps
            self.steps = steps
            //Store each step path polyline
            self.prepareSteps(steps: self.steps)
        }
    }
    
    func drawRoute(points : [String]) {
        for point in points {
            let path = GMSPath.init(fromEncodedPath: point)
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = UIColor.red
            polyline.map = self.mapView
        }
    }
    
    func prepareSteps(steps : [Step]) {
        for step in steps {
            //Recalculate route from that point in the map
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: step.startLocationLat,
                                            longitude: step.startLocationLong))
            path.add(CLLocationCoordinate2D(latitude: step.endLocationLat,
                                            longitude: step.endLocationLong))
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = UIColor.black.withAlphaComponent(0.5)
            self.stepPathPolylines.append(polyline)
        }
        
        //Update layout
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.navigationModeCollectionView.isHidden = true
    }
    
    //MARK : - Actions
    
    @IBAction func didTapOpenGMaps(_ sender: Any) {
        let url = URL(string : "comgooglemaps://?saddr=-33.878518,151.19954180&daddr=-33.877755,151.1984537&directionsmode=walking")!
        UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == navigationModeCollectionView) {
            return navigationModes.count
        } else {
            return steps.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == navigationModeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "navigationModeCell", for: indexPath) as! NavigationModeCell
            cell.navigationModeLbl.text = navigationModes[indexPath.row].rawValue.capitalized
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "directionCell", for: indexPath) as! DirectionCell
            let htmlDirection = steps[indexPath.row].instruction
            cell.durationLbl.text = steps[indexPath.row].duration
            cell.distanceLbl.text = steps[indexPath.row].distance
            do {
                let attrStr = try NSAttributedString(
                    data: htmlDirection.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                    options: [ .documentType : NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                cell.instructionLbl.attributedText = attrStr
                return cell
            } catch let error {
                print(error)
            }
            
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == navigationModeCollectionView {
            //Get directions for the selected navigation mode
            let navMode = navigationModes[indexPath.row].rawValue
            getDirections(navMode: navMode)
        } else {
            //Recalculate route from that point in the map
//            let path = GMSMutablePath()
//            let step = steps[indexPath.row]
//            path.add(CLLocationCoordinate2D(latitude: step.startLocationLat,
//                                                longitude: step.startLocationLong))
//            path.add(CLLocationCoordinate2D(latitude: step.endLocationLat,
//                                            longitude: step.endLocationLong))
//            let polyline = GMSPolyline.init(path: path)
//            polyline.strokeWidth = 5
//            polyline.strokeColor = UIColor.red.withAlphaComponent(0.5)
            
        }
    }
    
    func updateCellsLayout()  {
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/4
        for cell in collectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (view.bounds.width * 2.7)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsLayout()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //Remove all steps lines from the map
        for polyline in self.stepPathPolylines {
            polyline.map = nil
        }
        
        //Add the first visible cell step line to the map
        if self.collectionView.indexPathsForVisibleItems.first != nil {
            let visibleCells = self.collectionView.indexPathsForVisibleItems
                .sorted { $0.section < $1.section || $0.row < $1.row }
            let polyline = self.stepPathPolylines[(visibleCells.first?.row)!]
            polyline.map = self.mapView
        }
    }
    
}

extension ViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //User tapped at coordinate
    }
}

