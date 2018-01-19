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
    
    var originLat = 39.5975014
    var originLong = 2.644017
    
    var destinationLat = 39.6080321
    var destinationLong = 2.6448371
    
    var startMarker : GMSMarker!
    var endMarker : GMSMarker!

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var flowLayout: DirectionsCollectionViewFlowLayout!
    var steps = [Step]()
    var stepPathPolylines = [GMSPolyline]()
    
    var navigationModes = [navigationMode.driving,
                           navigationMode.transit,
                           navigationMode.walking]
    
    var selectedNavMode = navigationMode.driving
    
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
    
    func setMap() {
        
        // Update camera to fit start and end pois
        let startPoint = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        let endPoint = CLLocationCoordinate2D(latitude: destinationLat,longitude: destinationLong)
        let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: endPoint)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: cameraUpdate)
        
        //Set up markers
        setMarkers()
        
        //Set Map Style
        setMapStyle()
        
        //MapView Delegate
        mapView.delegate = self
    }
    
    func setMarkers() {
        // Creates a start marker in the center of the map.
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        startMarker.map = mapView
        self.startMarker = startMarker
        
        // Creates an end marker
        let endMarker = GMSMarker()
        endMarker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        endMarker.title = "Son Espases"
        endMarker.map = mapView
        self.endMarker = endMarker
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DirectionsAPI.shared.getDirections(originLat: originLat,
                                           originLong: originLong,
                                           destinationLat: destinationLat ,
                                           destinationLong:  destinationLong,
                                           navigationMode : navMode) { (route, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                if route != nil {
                    //Show route on map
                    self.drawRoute(points: [(route?.overviewPolylinePoints)!])
                    //Store steps
                    self.steps = (route?.legs.first?.steps)!
                    //Store each step path polyline
                    self.prepareSteps(steps: self.steps)
                    //Scroll to first item
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                } else {
                    print("No route available")
                }
               
            } else {
                //Handle error
                print("Error while trying to get directions")
            }
        }
    }
    
    func drawRoute(points : [String]) {
        
        //Clear previous routes
        mapView.clear()
        
        //Draw route on map
        for point in points {
            let path = GMSPath.init(fromEncodedPath: point)
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = UIColor.red
            polyline.map = self.mapView
        }
        
        //Set start and end markers
        setMarkers()
        
        // Update camera to fit start and end pois
        let startPoint = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        let endPoint = CLLocationCoordinate2D(latitude: destinationLat,longitude: destinationLong)
        let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: endPoint)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: cameraUpdate)
    }
    
    func prepareSteps(steps : [Step]) {
        
        self.stepPathPolylines.removeAll()
        
        for step in steps {
            let path = GMSPath.init(fromEncodedPath: step.polylinePoints)
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
        let url = URL(string : "comgooglemaps://?saddr=\(originLat),\(originLong)&daddr=\(destinationLat),\(destinationLong)&directionsmode=\(selectedNavMode.rawValue)")!
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
            cell.durationLbl.text = steps[indexPath.row].durationText
            cell.distanceLbl.text = steps[indexPath.row].distanceText
            cell.busLineLbl.text = steps[indexPath.row].transitDetail?.line.number
            cell.busLineColor.backgroundColor = steps[indexPath.row].transitDetail?.line.color
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
            selectedNavMode = navigationModes[indexPath.row]
            getDirections(navMode: navMode)
        } else {
            
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
        //Add the first visible cell step line to the map
        if self.collectionView.indexPathsForVisibleItems.first != nil {
            let visibleCells = self.collectionView.indexPathsForVisibleItems
                .sorted { $0.section < $1.section || $0.row < $1.row }
            
            var stepPolylines = [String]()
            for index in (visibleCells.first?.row)! ... self.stepPathPolylines.count-1 {
                let step = self.steps[index]
                stepPolylines.append(step.polylinePoints)
            }
            let startStep = self.steps[(visibleCells.first?.row)!]
            self.originLat = startStep.startLocationLat
            self.originLong = startStep.startLocationLong
            drawRoute(points: stepPolylines)
        }
    }
    
}

extension ViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //User tapped at coordinate
        self.originLat = coordinate.latitude
        self.originLong = coordinate.longitude
        getDirections(navMode: selectedNavMode.rawValue)
    }
}

