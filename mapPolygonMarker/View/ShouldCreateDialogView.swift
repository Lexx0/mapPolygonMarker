//
//  ShouldCreateDialogView.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/19/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit

class ShouldCreateDialogView: UIView {
    @IBOutlet weak var dialogLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
//    var delegate: ShouldCreateDialogDelegate!
    
    override func awakeFromNib() {
        self.okBtn.layer.cornerRadius = 7
        self.noBtn.layer.cornerRadius = 7
        self.frame.size.height = 100
        
        self.layer.cornerRadius = 12
    }
    
//    @IBAction func okBtnTapped(_ sender: Any) {
//        self.delegate.okBtnTapped()
//    }
//
//    @IBAction func noBtnTapped(_ sender: Any) {
//
//    }
    
}

//protocol ShouldCreateDialogDelegate: NSObjectProtocol{
//    func okBtnTapped() {
//
//    }
//
//    func noBtnTapped() {
//
//    }
//}
