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
//    public var storedImage: UIImage? = UIImage(named: "take-a-photo")
    let storedImage = Variable<UIImage>(UIImage(named: "take-a-photo")! )
    
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

extension MapMarkerVM {
    
    func presentActionSheet(vc: MapMarkerVC) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.pickCamera(vc)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.pickPhotoLibrary(vc)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func pickCamera(_ vc: MapMarkerVC) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = vc
            myPickerController.sourceType = .camera
                        vc.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func pickPhotoLibrary(_ vc: MapMarkerVC) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = vc
            myPickerController.sourceType = .photoLibrary
                        vc.present(myPickerController, animated: true, completion: nil)
        }
    }
}
