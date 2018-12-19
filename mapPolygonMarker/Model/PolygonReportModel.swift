//
//  PolygonReportModel.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/19/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class PolygonReportModel {
    var coordinates: [CLLocation]!
    let path: GMSPath!
    var photo: UIImage?
    var descr: String?
    var date: Date!
    
    init(coordinates: [CLLocation],
         path: GMSPath,
         photo: UIImage,
         descr: String,
         date: Date) {
        
        self.coordinates = coordinates
        self.path = path
        self.photo = photo
        self.descr = descr
        self.date = date
    }
}
