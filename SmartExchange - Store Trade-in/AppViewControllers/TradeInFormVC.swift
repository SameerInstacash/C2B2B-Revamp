//
//  TradeInFormVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 24/01/22.
//

import UIKit
import SwiftyJSON
import Luminous
import DropDown
import Alamofire
import AlamofireImage
import JGProgressHUD

class TradeInFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet weak var btnProceed: UIButton!
    
    let hud = JGProgressHUD()
    
    var tradeOrderId = ""
    var tradeValue = ""
    var tradeCurrency = ""
    
    
    var drop = UIDropDown()
    var arrDrop = [String]()
    
    var responseDictIN = [String : Any]()
    var responseDict = [String : Any]()
    var arrDictKeys = [Any]()
    var arrDictKeys1 = [String]()
    var arrDictValues = [[Any]]()
    
    var isHtml = true
    var setInfo = [String:String]()
    
    var bankDetails = [String:Any]()
    var bankDict = [String:Any]()
    var arrBankKeysMendatory = [String]()
    //var arrBankKeysOptional = [String]()
    var placeHold : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        self.getMaxisForm()
    
    }
    
    //MARK: Custom Methods
    
    func setUIElements() {
        
        self.lblTitle.text = self.getLocalizatioStringValue(key: "Trade In Online")
        
        self.hideKeyboardWhenTappedAroundView()
        self.setStatusBarColor(themeColor: AppThemeColor)
        
        self.lblPleaseEnter.text = self.getLocalizatioStringValue(key: "Please Enter your details below")
        self.btnProceed.setTitle(self.getLocalizatioStringValue(key: "PROCEED").uppercased(), for: .normal)
        
    }
    
    @objc func selectBankNameButtonClicked(_ sender: UITextField) {
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDrop
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            //sender.setTitle(item, for: .normal)
            sender.text = item
        }
        existingFileDropDown.show()
    }
    
    //MAR: IBActions
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {
                
        if isHtml {
//            let vc = OrderFinalVC()
//            vc.orderID = self.placedOrderId
//            vc.finalPrice = self.finalPriced
//            vc.selectPaymentType = self.selectedPaymentType
//            vc.selectCurrency = self.selectedCurrency
//            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
            
            for key in self.arrBankKeysMendatory {
                
                if self.bankDict[key] as? String == "" {
                    
                    if key == "tnc" {

                        DispatchQueue.main.async {
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please agree Terms & Conditions"))
                        }
                        
                        return
                    }else if key == "Bank Name" {
                        
                        DispatchQueue.main.async {
                            //self.showaAlert(message: "Please select \(key)")
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please select \(key)"))
                        }
                        
                        return
                    }else {

                        DispatchQueue.main.async {
                            //self.showaAlert(message: "Please Enter \(key)")
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Enter \(key)"))
                        }
                        
                        return
                    }
                    
                }
                
            }
        
            
            //setInfo["cartId"] = self.tradeOrderId
            //self.bankDetails = setInfo
            
            self.bankDict["cartId"] = self.tradeOrderId
            self.bankDetails = self.bankDict
            
            self.setMaxisFormToServer()
        }
        
    }
    
    //MARK:- webservice Get maxis form
    
    func showHudLoader(msg:String) {
        hud.textLabel.text = msg
        hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
    }
    
    func getMaxisForm() {
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "cartId" : self.tradeOrderId
                  ]
        
        print("params = \(params)")
    
        self.showHudLoader(msg: "")
        
        let webService = AF.request(AppBaseUrl + kgetMaxisForm, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        do {
                            let resp = try (JSONSerialization.jsonObject(with: responseData.data ?? Data(), options: []) as? [String:Any] ?? [:])
                            
                            print(resp)
                            
                            self.responseDict = resp["msg"] as? [String:Any] ?? [:]
                           
                            print(" First name is: \(self.responseDict)")
                            
                            for (ind,item) in self.responseDict.enumerated() {
                                print(ind)
                                //print(item)
                                
                                self.arrDictKeys1.append(item.key)
                                //self.arrDictKeys.append(item.key)
                                //self.arrDictValues.append([item.value])
                                
                                if item.key == "Bank Name" {
                                    let arr = (item.value as! NSArray)[3] as? [String]
                                    
                                    self.arrDrop = arr ?? []
                                    self.drop.options = self.arrDrop
                                }
                            }
                            
                            self.arrDictKeys = self.arrDictKeys1.sorted()
                            //print(self.arrDictKeys)
                            
                            for item in self.arrDictKeys {
                                let val = self.responseDict[item as? String ?? ""]
                                self.arrDictValues.append([val ?? []])
                            }
                            
                            // sameer 2/6/21
                            for (index,keyFld) in (self.arrDictKeys as! [String]).enumerated() {
                                let data = self.arrDictValues[index]
                                let arrData = data[0] as! Array<Any>
                                
                                if !((arrData[0] as? String) == "html") {
                                
                                    if arrData[1] as? Int == 1 {
                                        self.bankDict[keyFld] = ""
                                        self.arrBankKeysMendatory.append(keyFld)
                                    }else {
                                        self.bankDict[keyFld] = ""
                                        //self.arrBankKeysOptional.append(keyFld)
                                    }
                                    
                                }
                            }
                            
                            print(self.bankDict)
                            print(self.arrBankKeysMendatory)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.formTableView.dataSource = self
                                self.formTableView.delegate = self
                                
                                self.formTableView.reloadData()
                                //self.formTableView.tableFooterView = UIView()
                            }
                            
                        } catch let error as NSError {
                            print(error)
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception"))
                        }
                        
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
    
    func setMaxisFormToServer() {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: self.bankDetails, options:[])
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "formData" : jsonString
                  ]
        
        print("params = \(params)")
    
        self.showHudLoader(msg: "")
        
        let webService = AF.request(AppBaseUrl + ksetMaxisForm, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
                            vc.endGameOrderId = self.tradeOrderId
                            vc.endGameValue = self.tradeValue
                            vc.tradeCurrency = self.tradeCurrency
                            vc.isComeFrom = "TradeIn"
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                            //self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
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
   
    
    //MARK:- tableview Delegates methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDictValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = self.arrDictValues[indexPath.row]
        
        let arrData = data[0] as? Array<Any>
        
        if (arrData?[0] as? String) == "text" {
            
            isHtml = false
            
            let cellTextBox = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell", for: indexPath) as! TextBoxCell
            
            //cellTextBox.txtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellTextBox.txtField.placeholder = self.getLocalizatioStringValue(key: (self.arrDictKeys[indexPath.row] as? String ?? ""))
            
            cellTextBox.txtField.tag = indexPath.row
            cellTextBox.txtField.delegate = self
            
            
            cellTextBox.txtField.layer.cornerRadius = 5.0
            cellTextBox.txtField.layer.borderWidth = 1.0
            cellTextBox.txtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellTextBox.seperatorLbl.backgroundColor = .clear
            
            return cellTextBox
            
        }else if (arrData?[0] as? String) == "html" {
            
            self.formTableView.isScrollEnabled = true
                        
            let cellTextHtml = tableView.dequeueReusableCell(withIdentifier: "HtmlCell", for: indexPath) as! HtmlCell
            cellTextHtml.htmlTextView.attributedText =  (arrData?[3] as? String)?.htmlToAttributedString
            
            return cellTextHtml
            
        }else if (arrData?[0] as? String) == "select" {
            
            isHtml = false
            
            let cellTextSelect = tableView.dequeueReusableCell(withIdentifier: "SelectTextCell", for: indexPath) as! SelectTextCell
            
            cellTextSelect.selectTextField.tag = indexPath.row
            cellTextSelect.selectTextField.delegate = self
            //cellTextSelect.selectTextField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellTextSelect.selectTextField.placeholder = self.getLocalizatioStringValue(key: (self.arrDictKeys[indexPath.row] as? String ?? ""))
            
            cellTextSelect.selectTextField.addTarget(self, action: #selector(selectBankNameButtonClicked(_:)), for: .editingDidBegin)
            
            cellTextSelect.selectTextField.layer.cornerRadius = 5.0
            cellTextSelect.selectTextField.layer.borderWidth = 1.0
            cellTextSelect.selectTextField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellTextSelect.seperatorLbl.backgroundColor = .clear
            
            return cellTextSelect
            
        }else if (arrData?[0] as? String) == "mobile" {
            
            isHtml = false
            
            let cellMobNum = tableView.dequeueReusableCell(withIdentifier: "MobileNumberCell", for: indexPath) as! MobileNumberCell
            
            if let imgURL = URL.init(string: self.responseDictIN["paymentImage"] as? String ?? "") {
                //cellMobNum.paymentImgView.sd_setImage(with: imgURL)
                cellMobNum.paymentImgView.af.setImage(withURL: imgURL)
            }
            
            
            cellMobNum.mobileNumberTxtField.layer.cornerRadius = 5.0
            cellMobNum.mobileNumberTxtField.layer.borderWidth = 1.0
            cellMobNum.mobileNumberTxtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            cellMobNum.seperatorLbl.backgroundColor = .clear
            
            
            //cellMobNum.mobileNumberTxtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)
            cellMobNum.mobileNumberTxtField.placeholder = self.getLocalizatioStringValue(key: (self.arrDictKeys[indexPath.row] as? String ?? ""))
            
            cellMobNum.mobileNumberTxtField.tag = indexPath.row
            cellMobNum.mobileNumberTxtField.delegate = self
            
            return cellMobNum
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    
    //MARK:- UITextField Delegates methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //if CustomUserDefault.getCurrency() == "RM" {
            self.placeHold = textField.placeholder ?? ""
        //}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // sameer 11/6/21
        let ndx = IndexPath(row: textField.tag, section: 0)
        if let cell = self.formTableView.cellForRow(at: ndx) as? TextBoxCell {
            if cell.txtField.text?.isEmpty ?? false {
                self.bankDict[cell.txtField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.txtField.text ?? ""
            }
        }
        
        if let cell = self.formTableView.cellForRow(at: ndx) as? SelectTextCell {
            if cell.selectTextField.text?.isEmpty ?? false {
                self.bankDict[cell.selectTextField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.selectTextField.text ?? ""
            }
        }
        
        if let cell = self.formTableView.cellForRow(at: ndx) as? MobileNumberCell {
            if cell.mobileNumberTxtField.text?.isEmpty ?? false {
                self.bankDict[cell.mobileNumberTxtField.placeholder ?? ""] = ""
            }else {
                self.bankDict[self.placeHold] = cell.mobileNumberTxtField.text ?? ""
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
