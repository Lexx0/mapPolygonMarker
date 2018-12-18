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

class MapMarkerVC: UIViewController {

    var vm: MapMarkerVM!
    var selectedMapType: GMSMapViewType = .normal
//    var camera: GMSCameraPosition!
    
    var locationManager: CLLocationManager!
    var locations: [CLLocation] = []
    
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
            print("Draw Tapped")
        }
        Floaty.global.button.addItem("Clear Markers", icon: UIImage(named: "wiping")) { tap in
            print("Clear Tapped")
        }
        Floaty.global.button.addItem("View List", icon: UIImage(named: "view-list")) { tap in
            print("List Tapped")
        }
        
        Floaty.global.show()

    }
    
    func gmapSetup() {
        
        print(self.locations)
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
    }
}
