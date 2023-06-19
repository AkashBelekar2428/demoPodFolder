//
//  DataPickerView.swift
//  MFTAAuthenticationFactors
//
//  Created by Nishu Sharma on 16/06/23.
//

import UIKit
import Foundation

public protocol DataPickerDelegate : AnyObject {
    func DataPickerWithValue(value : String)
    func DataPickerDismiss()
}

public class DataPickerView:UIView {
    
    //MARK: IBOutlets
    
    @IBOutlet weak public var pickerView:UIPickerView!
    @IBOutlet weak var btnDone : UIButton!
    
    //MARK: Variables
    let nibName = "DataPickerView"
    public weak var delegate : DataPickerDelegate?
    var pickedValue = ""
    
    //MARK: System methods
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
     
    //MARK: Custom methods
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissComponent))
        tapGesture.numberOfTouchesRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
     
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        pickerView.tintColor = .black
//        pickerView.layer.borderColor = UIColor.gray.cgColor
//        pickerView.layer.borderWidth = 1.0
//        pickerView.layer.cornerRadius = 8.0
//        pickerView.clipsToBounds = true
        
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(UIColor.blue, for: .normal)
        btnDone.backgroundColor = UIColor.white
        btnDone.layer.cornerRadius = 6
        btnDone.clipsToBounds = true
        btnDone.layer.borderColor = UIColor.black.cgColor
        btnDone.layer.borderWidth = 1.0
      
        pickerView.reloadAllComponents()
        
    }
    
    @objc func dismissComponent() {
        self.delegate?.DataPickerDismiss()
    }
    
    func scrollToValue(value: String) {
        pickedValue = value
        if let index = countryArray.firstIndex(of: value){
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let bundel = Bundle(for: Mobile_Number.self)
        let nib = bundel.loadNibNamed(nibName, owner: self)?.first as? UIView
        return nib
    }
    
    
    //MARK: IBAction
    
    @IBAction func btnDone(_ sender:UIButton){
        self.delegate?.DataPickerWithValue(value: self.pickedValue)
    }
}


extension DataPickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let setCountryCode = countryArray[row]
        self.pickedValue = setCountryCode
        
    }
   
}
