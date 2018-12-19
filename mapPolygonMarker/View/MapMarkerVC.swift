//
//  MapMarkerVC.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/18/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit
import Floaty
import GoogleMaps
import CoreLocation
import RxCocoa
import RxSwift

class MapMarkerVC: UIViewController {

    var vm: MapMarkerVM!
    var selectedMapType: GMSMapViewType = .normal
    
    var locationManager: CLLocationManager!
    
    var locations: [CLLocation] = []
    var markerLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        floatySetup()
        gmapSetup()
    }
    
    func locationSetup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
    func floatySetup() {
        Floaty.global.button.addItem("Draw PolyGone", icon: UIImage(named: "document-add")) { tap in
            
            guard let mapView = self.view as? GMSMapView else  { return }
            var currentIndex = 0
            
            let path = GMSMutablePath()
            
            for item in self.markerLocations {
                let tempItem = item
                path.add(tempItem.coordinate)
                currentIndex += 1
                
                if currentIndex == self.markerLocations.count {
                    let firstItem = self.markerLocations[0]
                    path.add(firstItem.coordinate)
                }
            }
            
            let canCreateReport = self.vm.checkIfUserWithinLocation(self.locations.last!, polygon: path)
            
            if canCreateReport == true {
                
                self.awakeDialog()
                
//                self.vm.createReport(path)
            }
            
            let rectangle = GMSPolyline(path: path)
        
            rectangle.map = mapView
        }
        
        Floaty.global.button.addItem("Clear Markers", icon: UIImage(named: "wiping")) { tap in
            guard let mapView = self.view as? GMSMapView else  { return }
            self.markerLocations.removeAll()
            mapView.clear()
        }
        
        Floaty.global.button.addItem("View List", icon: UIImage(named: "view-list")) { tap in
            print("List Tapped")
        }
        
        Floaty.global.button.openAnimationType = .slideLeft
        Floaty.global.button.hasShadow = true
        
        Floaty.global.show()
    }
    
    func gmapSetup() {
        
        let camera = GMSCameraPosition.camera(withLatitude: self.locations.first?.coordinate.latitude ?? 49.0391,
                                              longitude: self.locations.first?.coordinate.longitude ?? 28.1086,
                                              zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = self.selectedMapType
        mapView.isMyLocationEnabled = true
        
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
        
        mapView.delegate = self
        self.view = mapView
        
    }
    
    func awakeDialog() {
        
        let dialogView = UINib(nibName: "ShouldCreateDialogView", bundle: nil)
            .instantiate(withOwner: self.view, options: nil)
            .first as! ShouldCreateDialogView
        
        dialogView.frame.size.width = self.view.frame.width*0.7
        dialogView.frame.origin.y = (self.view.frame.height*0.5) - 70
        dialogView.frame.origin.x = dialogView.frame.width*0.2
        
        dialogView.okBtn.rx.tap
            .subscribe { tap in
                print("TAAAP!")
        }.disposed(by: self.vm.bag)
        
        dialogView.noBtn.rx.tap
            .subscribe { tap in
                dialogView.removeFromSuperview()
                
            }.disposed(by: self.vm.bag)
        
        self.view.addSubview(dialogView)
//        view RXSwift
    }
    
}


extension MapMarkerVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.locations.append(location)
    }
}



extension MapMarkerVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        guard let mapView = self.view as? GMSMapView else {
            return
        }
            let marker = GMSMarker(position: coordinate)
            marker.icon = UIImage(named: "location-pin")
            marker.map = mapView
        
            let locationNew = CLLocation(latitude: coordinate.latitude,
                                         longitude: coordinate.longitude)
            self.markerLocations.append(locationNew)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        // load nib with action options ??
        
        var index = 0

        for item in self.markerLocations {
            if (item.coordinate.latitude == marker.position.latitude) && (item.coordinate.longitude == marker.position.longitude) {
                self.markerLocations.remove(at: index)
            }
            index += 1
        }
        
        marker.map = nil
        return true
    }
}
