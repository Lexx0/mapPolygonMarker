//
//  OriginalVC.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/18/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit

class OriginalVC: UIViewController {

    fileprivate var vm: OriginalVM!
    
    @IBOutlet weak var proceedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vm = OriginalVM()
        self.initialSetup()
    }
    
    fileprivate func initialSetup() {
        let backGroumndImg = UIImage(named: "backGround")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backGroumndImg
        imageView.center = self.view.center
        
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.proceedBtn.backgroundColor = .lightGray
        self.proceedBtn.layer.cornerRadius = 5
        self.proceedBtn.layer.borderWidth = 1
        self.proceedBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        self.proceedBtn.setTitle("Don't Panic", for: .normal)
    }
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
        self.vm.pushMarkerVC()
    }
    
}
