//
//  ReportForm.swift
//  mapPolygonMarker
//
//  Created by admin2 on 12/19/18.
//  Copyright © 2018 admin2. All rights reserved.
//

import UIKit

class ReportForm: UIView {

    @IBOutlet weak var takeAphotoBtn: UIButton!
    @IBOutlet weak var cancelImg: UIButton!
    @IBOutlet weak var dateInPut: UITextField!
    @IBOutlet weak var descrInput: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        self.takeAphotoBtn.setImage(UIImage(named: "take-a-photo"), for: .normal)
        
        initialSetup()
    }
    
    func initialSetup() {
        self.saveBtn.backgroundColor = .blue
        self.saveBtn.setTitle("СОХРАНИТЬ", for: .normal)
        self.saveBtn.tintColor = .white
        self.saveBtn.layer.cornerRadius = 12
        
        self.cancelBtn.layer.cornerRadius = 12
        self.cancelBtn.tintColor = .red
        self.cancelBtn.setTitle("ОТМЕНА", for: .normal)
        self.cancelBtn.backgroundColor = .gray
        
        self.cancelImg.isHidden = true
        self.cancelImg.isUserInteractionEnabled = false
        self.datePicker.isHidden = true
        self.datePicker.isUserInteractionEnabled = false
        
        //        self.dateInPut.inputView = self.datePicker
        //        var dateFormatter = NSDateFormatter()
        //        dateFormatter.dateFormat = "dd MMM yyyy"
        
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = NSCalendar.current.date(byAdding: .day, value: -7, to: Date())
        //        self.datePicker.maximumDate = Date()
    }
}
