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
    //var coordinates: [CLLocation]!
    //var path: GMSPath!
    var encodedPath: String!
    var imageData: Data?
    var descr: String?
    var date: Date!
    
    init(/*coordinates: [CLLocation],*/
         //path: GMSPath,
         encodedPath: String,
         imageData: Data,
         descr: String,
         date: Date) {
        
        self.encodedPath = encodedPath
        //self.coordinates = coordinates
        //self.path = path
        self.imageData = imageData
        self.descr = descr
        self.date = date
    }
}
