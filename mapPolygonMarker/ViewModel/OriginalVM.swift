//
//  OriginalVM.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/18/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit

final class OriginalVM {
    
    static let shared = OriginalVM()
    
    func pushMarkerVC() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationSontroller: UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let uiWindow: UIWindow = UIApplication.shared.delegate!.window!!
        uiWindow.rootViewController = navigationSontroller
        
        let vc: MapMarkerVC = storyBoard.instantiateViewController(withIdentifier: "MapMarkerVC") as! MapMarkerVC
        
        vc.navigationItem.hidesBackButton = true
        
        vc.vm = MapMarkerVM()
        
        defer {
            navigationSontroller.pushViewController(vc, animated: true)
        }
    }
}
