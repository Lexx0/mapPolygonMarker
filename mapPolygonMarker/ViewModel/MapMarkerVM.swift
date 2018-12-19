//
//  MapMarkerVM.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/18/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

import RxSwift
import RxCocoa

final class MapMarkerVM {
    
    static let shared = MapMarkerVM()
    
    let bag = DisposeBag()
    
    func getDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let todaysDate = formatter.string(from: date)
        
        return todaysDate
    }
    
    func saveModel() {
        
    }
    
    func getAllModels() {
        
    }
    
    func editModel() {
    
    }
    
    func checkIfUserWithinLocation(_ yourPoint: CLLocation, polygon: GMSPath) -> Bool {

        let outcome = GMSGeometryContainsLocation(yourPoint.coordinate, polygon, false)
        
        return outcome
    }
    
    func createReport(_ rectangle:  GMSMutablePath) {
        print("can create")
    }
}
