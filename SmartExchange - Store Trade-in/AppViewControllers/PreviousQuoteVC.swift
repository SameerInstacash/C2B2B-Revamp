//
//  PreviousQuoteVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 12/07/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON

class PreviousQuoteVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRefNumTitle: UILabel!
    @IBOutlet weak var txtFieldRefNum: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    var orderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        if self.orderID != "" {
            self.txtFieldRefNum.text = orderID
        }
    }
    
    //MARK:- IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        guard self.txtFieldRefNum.text != "" else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Enter Reference Number"))
            return
        }
        
        self.view.endEditing(true)
        
        if reachability?.connection.description != "No Connection" {
            self.getSessionQuote()
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }
        
    }
        
    //MARK:- Custom Methods
  
    func setUIElements() {
        
        self.lblTitle.text = self.getLocalizatioStringValue(key: "SMART EXCHANGE")
        self.lblRefNumTitle.text = self.getLocalizatioStringValue(key: "Reference Number")
        self.txtFieldRefNum.placeholder = self.getLocalizatioStringValue(key: "Store Token")
        self.btnSubmit.setTitle(self.getLocalizatioStringValue(key: "Submit"), for: .normal)
        
        self.hideKeyboardWhenTappedAroundView()
        self.setStatusBarColor(themeColor: AppThemeColor)
        self.setPaddingOnTextField()
        
        self.txtFieldRefNum.layer.cornerRadius = AppBtnCornerRadius
        self.txtFieldRefNum.layer.borderWidth = 0.5
        self.txtFieldRefNum.layer.borderColor = AppThemeColor.cgColor
        
        self.btnSubmit.layer.cornerRadius = AppBtnCornerRadius
        
        self.lblRefNumTitle.text = self.getLocalizatioStringValue(key: "Reference Number")
       
    }
    
    func setPaddingOnTextField() {
        
        let padd = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: self.txtFieldRefNum.bounds.height))
        padd.text = ""
        padd.font = UIFont.init(name: AppRobotoFontRegular, size: 16.0)
        padd.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        padd.textAlignment = .center
        padd.isUserInteractionEnabled = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtFieldRefNum.bounds.height))
        paddingView.addSubview(padd)
        self.txtFieldRefNum.leftView = paddingView
        self.txtFieldRefNum.leftViewMode = .always
        
    }
    
    //MARK:- Web Service Methods
    func showHudLoader() {
        hud.textLabel.text = ""
        hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
    }
    
    func getSessionQuote() {
        
        var IMEI = ""
        
        if let imei = AppUserDefaults.value(forKey: "imei_number") as? String {
            IMEI = imei
        }
        
        if let baseUrl = AppUserDefaults.value(forKey: "AppBaseUrl") as? String {
            AppBaseUrl = baseUrl
        }
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "IMEINumber" : IMEI,
                  "quotationId" : self.txtFieldRefNum.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]
        
        print("params = \(params)")
    
        self.showHudLoader()
        
        let webService = AF.request(AppBaseUrl + kGetSessionIdbyIMEIURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuoteDetailVC") as! QuoteDetailVC
                        vc.QuoteJSON = json
                        vc.orderId = self.txtFieldRefNum.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception"))
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!"))
                break
            }
      
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
