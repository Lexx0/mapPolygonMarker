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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navSetup()
        locationSetup()
        floatySetup()
        gmapSetup()
    }
    
    func navSetup() {
        self.navigationController?.isNavigationBarHidden = true
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
            let path = self.vm.getPath()
            let canCreateReport = self.vm.checkIfUserWithinLocation(self.vm.locations.last!, polygon: path)
            
            if canCreateReport == true {
                self.awakeDialog()
            }
            
            let rectangle = GMSPolyline(path: path)
            rectangle.map = mapView
        }
        
        Floaty.global.button.addItem("Clear Markers", icon: UIImage(named: "wiping")) { tap in
            guard let mapView = self.view as? GMSMapView else  { return }
            self.vm.markerLocations.removeAll()
            mapView.clear()
        }
        
        Floaty.global.button.addItem("View List", icon: UIImage(named: "view-list")) { tap in
            self.vm.getAllModels()
        }
        
        Floaty.global.button.openAnimationType = .slideLeft
        Floaty.global.button.hasShadow = true
        
        Floaty.global.show()
    }
    
    func gmapSetup() {
        
        let camera = GMSCameraPosition.camera(withLatitude: self.vm.locations.first?.coordinate.latitude ?? 49.0391,
                                              longitude: self.vm.locations.first?.coordinate.longitude ?? 28.1086,
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
        
        dialogView.frame.size.width = self.view.frame.width*0.8
        dialogView.frame.origin.y = (self.view.frame.height*0.5) - 70
        dialogView.frame.origin.x = dialogView.frame.width*0.11
        
        dialogView.okBtn.rx.tap
            .subscribe { tap in
                self.createReport()
                Floaty.global.hide()
                dialogView.removeFromSuperview()
        }.disposed(by: self.vm.bag)
        
        dialogView.noBtn.rx.tap
            .subscribe { tap in
                dialogView.removeFromSuperview()
                
            }.disposed(by: self.vm.bag)
        
        self.view.addSubview(dialogView)

    }
    
    func createReport() {
        
        let reportForm = UINib(nibName: "ReportForm", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! ReportForm
        
        reportForm.frame.size.width = self.view.frame.width*0.8
        reportForm.frame.size.height = self.view.frame.height*0.8
        reportForm.frame.origin.y = self.view.frame.height*0.1
        
        reportForm.frame.origin.x = self.view.frame.width*0.1
        
        self.vm.storedImage.asObservable().subscribe{ imageChange in
            reportForm.takeAphotoBtn.setImage(self.vm.storedImage.value, for: .normal)
            
            if self.vm.storedImage.value == UIImage(named: "take-a-photo") {
                reportForm.cancelImg.isHidden = true
                reportForm.cancelImg.isUserInteractionEnabled = false
            } else {
                reportForm.cancelImg.isHidden = false
                reportForm.cancelImg.isUserInteractionEnabled = true
            }
            
        }.disposed(by: self.vm.bag)
        
        reportForm.cancelImg.rx.tap.subscribe { _ in
            self.vm.storedImage.value = UIImage(named: "take-a-photo")!
            reportForm.cancelImg.isHidden = true
            reportForm.cancelImg.isUserInteractionEnabled = false
        }.disposed(by: self.vm.bag)
        
        reportForm.takeAphotoBtn.rx.tap
            .subscribe { tap in
                self.vm.presentActionSheet(vc: self)
        }.disposed(by: self.vm.bag)
        
        reportForm.dateInPut.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe{ _ in

                reportForm.datePicker.isHidden = !reportForm.datePicker.isHidden
                reportForm.datePicker.isUserInteractionEnabled = !reportForm.datePicker.isUserInteractionEnabled
                
                reportForm.saveBtn.isHidden = !reportForm.saveBtn.isHidden
                reportForm.saveBtn.isUserInteractionEnabled = !reportForm.saveBtn.isUserInteractionEnabled
                reportForm.cancelBtn.isHidden = !reportForm.cancelBtn.isHidden
                reportForm.cancelBtn.isUserInteractionEnabled = !reportForm.cancelBtn.isUserInteractionEnabled
                
        }.disposed(by: self.vm.bag)
        
        reportForm.datePicker.rx.value.bind { [weak self] _ in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            reportForm.dateInPut.text = dateFormatter.string(from: reportForm.datePicker.date)
            
        }.disposed(by: self.vm.bag)
        
        reportForm.saveBtn.rx.tap.subscribe { tap in
            self.vm.saveModel(reportForm.datePicker!.date,
                              descr: reportForm.descrInput.text)
            print("DATE??", reportForm.datePicker!.date)
            Floaty.global.show()
            reportForm.removeFromSuperview()
        }.disposed(by: self.vm.bag)
        
        reportForm.cancelBtn.rx.tap.subscribe { tap in
            Floaty.global.show()
            reportForm.removeFromSuperview()
        }.disposed(by: self.vm.bag)
        
        
        reportForm.descrInput.rx.didBeginEditing.subscribe({ n in
            reportForm.frame.origin.y -= 160
            reportForm.descrInput.text = ""
        }).disposed(by: self.vm.bag)
        
        
        reportForm.descrInput.rx.didEndEditing.subscribe { _ in
            reportForm.frame.origin.y += 160
        }.disposed(by: self.vm.bag)
        
        self.view.addSubview(reportForm)
    }
    
}


extension MapMarkerVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.vm.locations.append(location)
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
            self.vm.markerLocations.append(locationNew)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        /*?? load nib with action options
        that includes all the possible manipulations with existing polyGon,
         such as: edit, add photo, etc
        */
        
        var index = 0

        for item in self.vm.markerLocations {
            if (item.coordinate.latitude == marker.position.latitude) && (item.coordinate.longitude == marker.position.longitude) {
                self.vm.markerLocations.remove(at: index)
            }
            index += 1
        }
        
        marker.map = nil
        return true
    }
}


// image and camera pickers logic goes here
extension MapMarkerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        self.vm.storedImage.value = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
}
