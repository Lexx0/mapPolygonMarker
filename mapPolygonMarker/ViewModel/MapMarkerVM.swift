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
import CoreData
import RxSwift
import RxCocoa

final class MapMarkerVM {
    
    static let shared = MapMarkerVM()

    let storedImage = Variable<UIImage>(UIImage(named: "take-a-photo")! )
    fileprivate var managedObjectContext: NSManagedObjectContext!
    
    var locations: [CLLocation] = []
    var markerLocations: [CLLocation] = []
    
    var model: PolygonReportModel! // array for future getAllModels?
    
    let bag = DisposeBag()
    
    func getDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let todaysDate = formatter.string(from: date)
        
        return todaysDate
    }
    
    func getPath() -> GMSMutablePath {
        let path = GMSMutablePath()
        var currentIndex = 0
        for item in self.markerLocations {
            let tempItem = item
            path.add(tempItem.coordinate)
            currentIndex += 1
            
            if currentIndex == self.markerLocations.count {
                let firstItem = self.markerLocations[0]
                path.add(firstItem.coordinate)
            }
        }
        return path
    }
    
    func saveModel(_ date: Date, descr: String) {

        let stringPath = self.getPath()
        let encodedPath = stringPath.encodedPath()
        let imageData = self.storedImage.value.pngData()!
        
        let model = PolygonReportModel(encodedPath: encodedPath,
                                       imageData: imageData,
                                       descr: descr,
                                       date: date)
        self.model = model
        
        //saving to CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        let newsEntity = NSEntityDescription.entity(forEntityName: "PolygonReportModel", in: managedObjectContext)
        
        let storageItem = NSManagedObject(entity: newsEntity!, insertInto: self.managedObjectContext)
        
        storageItem.setValue(model.date, forKey: "date")
        storageItem.setValue(model.descr!, forKey: "descr")
        storageItem.setValue(model.encodedPath, forKey: "encodedPath")
        storageItem.setValue(model.imageData, forKey: "imageData")
        
        do {
            try self.managedObjectContext.save()
            
        } catch let error as NSError {
            print("ERROR: ", error, "end user info: ", error.userInfo)
        }
    }
    
    func getAllModels() {
        //decode str to path
//        let encodedString = model.encodedString
//        let path = GMSPath(fromEncodedPath: encodedString)
        
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
