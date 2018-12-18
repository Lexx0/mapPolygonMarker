//
//  MapMarkerVC.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/18/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapMarkerVC: UIViewController {

    var vm: MapMarkerVM!
    var selectedMapType: GMSMapViewType = .normal
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup() {
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.mapType = self.selectedMapType
        mapView.isMyLocationEnabled = true
        
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
        
//        locationManager.distanceFilter = 1000
//        locationManager.delegate = self as! 
//        locationManager.requestWhenInUseAuthorization()
        

        
        self.view = mapView
    }
}
