//
//  ViewController.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 12/07/21.
//

import UIKit

class ImeiVC: UIViewController {
    
    @IBOutlet weak var lblEnterIMEI: UILabel!
    @IBOutlet weak var txtFieldImei: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let IMEI = AppUserDefaults.value(forKey: "imei_number") as? String {
            self.navigateToTokenPage(IMEI)
        }
        
        self.setUIElements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    //MARK:- IBAction
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if UIDevice.current.model.hasPrefix("iPad") {
            
            if (self.txtFieldImei.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) > 0 {
                self.navigateToTokenPage(self.txtFieldImei.text ?? "")
            }else{
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Invalid SERIAL/IMEI Number Entered"))
            }
            
        }else {
            
            if self.txtFieldImei.text?.count == 15 {
                
                if (self.txtFieldImei.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) > 0 {
                    self.navigateToTokenPage(self.txtFieldImei.text ?? "")
                }else{
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "Invalid IMEI Number Entered"))
                }
                
            }else{
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Enter a valid 15-digit IMEI Number"))
            }
            
        }
    
        
    }
    
    //MARK:- Custom Methods
    func navigateToTokenPage(_ imei : String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreTokenVC") as! StoreTokenVC
        AppUserDefaults.setValue(imei, forKey: "imei_number")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUIElements() {
        
        self.lblEnterIMEI.text = self.getLocalizatioStringValue(key: "Please Enter IMEI of your device") 
        
        self.hideKeyboardWhenTappedAroundView()
        self.setStatusBarColor(themeColor: AppThemeColor)
        
        self.txtFieldImei.layer.cornerRadius = AppBtnCornerRadius
        self.btnSubmit.layer.cornerRadius = AppBtnCornerRadius
    }

    
}

