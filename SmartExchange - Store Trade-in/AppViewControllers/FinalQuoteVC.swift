//
//  FinalQuoteVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 14/07/21.
//

import UIKit
import JGProgressHUD
import SwiftyJSON
import Alamofire
import AlamofireImage
import Luminous
import BiometricAuthentication
import DKCamera
import WebKit

class FinalQuoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblProductDetail: UILabel!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceImageView: UIImageView!
    //@IBOutlet weak var lblDeviceBrand: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    //@IBOutlet weak var lblOrderRef: UILabel!
    @IBOutlet weak var refValueLabel: UILabel!
    @IBOutlet weak var refValue: UILabel!
    //@IBOutlet weak var lblQuoteAmount: UILabel!
    //@IBOutlet weak var btnFinish: UIButton!
    
    @IBOutlet weak var priceInfoView: UIView!
    @IBOutlet weak var lblPriceInfo: UILabel!
    
    @IBOutlet weak var lblOfferedPriceInfo: UILabel!
    @IBOutlet weak var lblDiagnosisChargeInfo: UILabel!
    @IBOutlet weak var lblEstimatedPriceInfo: UILabel!
    @IBOutlet weak var lblTotalAmountInfo: UILabel!
    
    @IBOutlet weak var lblOfferedAmount: UILabel!
    @IBOutlet weak var lblDiagnosisAmount: UILabel!
    @IBOutlet weak var lblEstimatedAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var diagnoseChargeInfoView: UIView!
    @IBOutlet weak var diagnoseChargeView: UIView!
    
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var quoteTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var baseWebView: UIView!
    @IBOutlet weak var webViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var btnPromoCode: UIButton!
    @IBOutlet weak var promoCodeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnTradeInOnline: UIButton!
    @IBOutlet weak var btnUploadId: UIButton!
    @IBOutlet weak var backHomeBtn: UIButton!
    
    @IBOutlet weak var voucherAmountInfoView: UIView!
    @IBOutlet weak var voucherAmountView: UIView!
    @IBOutlet weak var lblVoucherAmountInfo: UILabel!
    @IBOutlet weak var lblVoucherAmount: UILabel!
    
   
    ////
    
    ////
    
    //@IBOutlet weak var skipView: UIView!
    //@IBOutlet weak var skipViewHeightConstraint : NSLayoutConstraint!
    //@IBOutlet weak var lblYouCouldBe: UILabel!
    //@IBOutlet weak var lblGetUpto: UILabel!
    //@IBOutlet weak var skipViewTopConstraint : NSLayoutConstraint!
    //@IBOutlet weak var skipTableView: UITableView!
    //@IBOutlet weak var btnReturnTests: UIButton!
    
    var webView: WKWebView!
    var loadableUrlStr: String?
    
    var trdValue = ""
    var trdCurrency = ""
    var voucherOrderID = ""
    
    let hud = JGProgressHUD()
    let reachability: Reachability? = Reachability()
    var metaDetails = JSON()
    var currentOrderId = ""
    var arrFailedAndSkipedTest = [ModelCompleteDiagnosticFlow]()
    
    var arrQuestion = [String]()
    var arrAnswer = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vouEnable = UserDefaults.standard.value(forKey: "isVoucherEnable") as? Int {
            if vouEnable == 0 {
                self.btnPromoCode.isHidden = true
                self.promoCodeViewHeight.constant = 0
            }else {
                
                if UIDevice.current.model.hasPrefix("iPad") {
                    self.btnPromoCode.isHidden = false
                    self.promoCodeViewHeight.constant = 50
                }else {
                    self.btnPromoCode.isHidden = false
                    self.promoCodeViewHeight.constant = 40
                }
                
            }
        }
        
        if reachability?.connection.description != "No Connection" {
            self.getpriceCalculation()
        }else {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
        }

        DispatchQueue.main.async {
            self.setDeviceData()
            self.setUIElements()
        }
        
        DispatchQueue.main.async {
            
            //let imgDEf = URL(string: "https://instacash.blob.core.windows.net/static/img/products/default.png")
            //self.productName.text = UserDefaults.standard.string(forKey: "productName")
            //self.deviceName = UserDefaults.standard.string(forKey: "productName")!
          
            if let str = UserDefaults.standard.string(forKey: "productImage") {
                if let url = URL.init(string: str) {
                    self.downloadImage(url: url)
                }
            }
            
            //self.lblOrderRef.isHidden = true
            self.refValueLabel.isHidden = true
            self.refValue.isHidden = true
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.skipTableView.register(UINib(nibName: "SkipTestCell", bundle: nil), forCellReuseIdentifier: "SkipTestCell")
        self.quoteTableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
        
        self.quoteTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        //self.createTableFromPassFailedTests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.quoteTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK:- IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tradeInOnlineBtnPressed(_ sender: UIButton) {
        
        AppUserDefaults.set(false, forKey: "UploadId")
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradeInFormVC") as! TradeInFormVC
        vc.tradeOrderId = self.currentOrderId
        vc.tradeValue = self.trdValue
        vc.tradeCurrency = self.trdCurrency
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backToHomeBtnClicked(_ sender: UIButton) {
        
        AppUserDefaults.set(false, forKey: "UploadId")
        
        AppResultJSON = JSON()
        AppResultString = ""
        AppHardwareQuestionsData = nil
        hardwareQuestionsCount = 0
        AppQuestionIndex = -1
        self.resetAppUserDefaults()
        
        /*
        self.dismiss(animated: false) {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.navigateToLoginScreen()
            }
        }
        */

        if #available(iOS 13.0, *) {
            
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sd.navigateToLoginScreen()
            }
            
        } else {
            // Fallback on earlier versions
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.navigateToLoginScreen()
            }
        }
    
    }
    
    @IBAction func finishBtnPressed(_ sender: UIButton) {
        //self.NavigateToHomePage()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
        vc.orderId = self.currentOrderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func uploadIdBtnPressed(_ sender: UIButton) {
        
        let camera = DKCamera()
        
        camera.didCancel = {
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
        
            DispatchQueue.main.async {
                
                self.dismiss(animated: true, completion: nil)
                
                let newImage = self.resizeImage(image: image!, newWidth: 800)
                let backgroundImage = newImage
                let watermarkImage = #imageLiteral(resourceName: "watermark")
                UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
                backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: backgroundImage.size.width, height: backgroundImage.size.height))
                watermarkImage.draw(in: CGRect(x: 0.0, y: 0.0, width: watermarkImage.size.width, height: backgroundImage.size.height))
                
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
               
                let imageData:Data = (result ?? UIImage()).jpegData(compressionQuality: 1.0) ?? Data()
                
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                
                self.uploadIdProof(photoStr: strBase64)
                
            }
            
        }
        
        self.present(camera, animated: true, completion: nil)
    }
    
    @IBAction func returnTestsBtnPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Custom Methods
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
  
    func setUIElements() {
        
        let langStr = Locale.current.languageCode
        if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "VI") || langStr == "vi" {
            self.priceInfoView.isHidden = false
        }else {
            self.priceInfoView.isHidden = true
        }
        
        self.lblTitle.text = self.getLocalizatioStringValue(key: "SMART EXCHANGE")
        self.lblPriceInfo.text = self.getLocalizatioStringValue(key: "price_info")
        
        self.lblProductDetail.text = self.getLocalizatioStringValue(key: "Product details")
        self.lblOfferedPriceInfo.text = self.getLocalizatioStringValue(key: "Offered Price")
        self.lblDiagnosisChargeInfo.text = self.getLocalizatioStringValue(key: "Diagnosis Charges")
        self.lblEstimatedPriceInfo.text = self.getLocalizatioStringValue(key: "Estimated Amount")
        self.lblVoucherAmountInfo.text = self.getLocalizatioStringValue(key: "Voucher Amount")
        self.lblTotalAmountInfo.text = self.getLocalizatioStringValue(key: "Total Amount")
        
        
        self.btnUploadId.setTitle(self.getLocalizatioStringValue(key: "Upload Id Proof").uppercased() , for: .normal)
        self.btnTradeInOnline.setTitle(self.getLocalizatioStringValue(key: "Trade In Online").uppercased(), for: .normal)
        self.backHomeBtn.setTitle(self.getLocalizatioStringValue(key: "Home").uppercased(), for: .normal)
        self.btnPromoCode.setTitle(self.getLocalizatioStringValue(key: "Have a promo code? Click here").uppercased(), for: .normal)
        self.btnPromoCode.layer.cornerRadius = 5
       
        //self.lblYouCouldBe.setLineHeight(lineHeight: 3.0)
        //self.lblYouCouldBe.textAlignment = .left
        
        //self.lblGetUpto.setLineHeight(lineHeight: 3.0)
        //self.lblGetUpto.textAlignment = .left
        
        self.setStatusBarColor(themeColor: AppThemeColor)
        
        //self.lblQuoteAmount.layer.cornerRadius = AppBtnCornerRadius
        //self.lblQuoteAmount.layer.borderWidth = 1.0
        //self.lblQuoteAmount.layer.borderColor = AppThemeColor.cgColor
        
        self.deviceView.layer.cornerRadius = AppBtnCornerRadius
        //self.btnFinish.layer.cornerRadius = AppBtnCornerRadius
        self.btnUploadId.layer.cornerRadius = AppBtnCornerRadius
        
        self.quoteTableView.layer.cornerRadius = AppBtnCornerRadius
        
        //self.skipView.layer.cornerRadius = AppBtnCornerRadius
        //self.btnReturnTests.layer.cornerRadius = AppBtnCornerRadius
        
        
    }
    
    func setDeviceData() {
                
        if let pBrand = AppUserDefaults.string(forKey: "product_brand") {
            print(pBrand)
            //self.lblDeviceBrand.text = pBrand
        }
        
        if let pName = AppUserDefaults.string(forKey: "productName") {
            self.lblDeviceName.text = pName.replacingOccurrences(of: "Apple ", with: "")
        }else {
            self.lblDeviceName.text = ""
        }
        
        if let pImage = AppUserDefaults.string(forKey: "productImage") {
            if let imgUrl = URL(string: pImage) {
                self.deviceImageView.af.setImage(withURL: imgUrl)
            }
        }
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                print("TableView size is : ", newsize)
                self.quoteTableViewHeightConstraint.constant = newsize.height + 0.0
            }
        }
    }
    
    //MARK:- Web Service Methods
    func showHudLoader(msg:String) {
        hud.textLabel.text = msg
        hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
    }
    
    func getpriceCalculation() {
        
        var IMEI = ""
        var productId = ""
        var storeCode = ""
        
        if let pId = AppUserDefaults.string(forKey: "product_id") {
            productId = pId
        }
        
        if let sCode = AppUserDefaults.string(forKey: "store_code") {
            storeCode = sCode
        }
        
        if let imei = AppUserDefaults.value(forKey: "imei_number") as? String {
            IMEI = imei
        }
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "imei" : IMEI,
                  "isAppCode" : "1",
                  "str" : AppResultString,
                  "storeCode" : storeCode,
                  "productId" : productId]
        
        print("params = \(params)")
    
        self.showHudLoader(msg: self.getLocalizatioStringValue(key: "Getting Price..."))
        
        let webService = AF.request(AppBaseUrl + kPriceCalcNewURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            //self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        if  let offerpriceString = json["msg"].string {
                                                        
                            DispatchQueue.main.async {
                                
                                let finalSummaryText = json["productDescription"].stringValue
                                print("finalSummaryText is:",finalSummaryText)
                                
                                var arrSummaryString : [String?] = finalSummaryText.components(separatedBy: ";")
                                
                                var arrItem = [""]
                                
                                for _ in arrSummaryString {
                                    if let ind = arrSummaryString.firstIndex(of: "") {
                                        arrSummaryString.remove(at: ind)
                                    }
                                }
                                
                                for item in arrSummaryString {
                                    arrItem = item?.components(separatedBy: "->") ?? []
                                    
                                    if arrItem.count > 1 {
                                        
                                        let quest = arrItem[0].replacingOccurrences(of: "'", with: "")
                                        let answ = arrItem[1].replacingOccurrences(of: "'", with: "")
                                        self.arrQuestion.append(self.getLocalizatioStringValue(key: quest))
                                        self.arrAnswer.append(self.getLocalizatioStringValue(key: answ))
                                    
                                        //self.arrQuestion.append(arrItem[0].replacingOccurrences(of: "'", with: ""))
                                        //self.arrAnswer.append(arrItem[1].replacingOccurrences(of: "'", with: ""))
                                    
                                    }else {
                                        
                                        let pre = self.arrAnswer.last
                                        //let val = (pre ?? "") + " & " + arrItem[0]
                                        
                                        let val = self.getLocalizatioStringValue(key: (pre ?? "")) + " & " + self.getLocalizatioStringValue(key: arrItem[0])
                                        let key = self.arrQuestion.last
                                        
                                        self.arrQuestion.removeLast()
                                        self.arrAnswer.removeLast()
                                        
                                        let quest = key?.replacingOccurrences(of: "'", with: "") ?? ""
                                        let answ = val.replacingOccurrences(of: "& '", with: "")
                                        self.arrQuestion.append(self.getLocalizatioStringValue(key: quest))
                                        self.arrAnswer.append(answ)
                                        
                                        
                                        //self.arrQuestion.append(key?.replacingOccurrences(of: "'", with: "") ?? "")
                                        //self.arrAnswer.append(val.replacingOccurrences(of: "& '", with: ""))
                                        
                                    }
                                }
                                
                                    self.quoteTableView.dataSource = self
                                    self.quoteTableView.delegate = self
                                    self.quoteTableView.reloadData()
                                
                            }
                            
                            
                            let jsonString = AppUserDefaults.string(forKey: "currencyJson") ?? ""
                            var multiplier : Float = 1.0
                            var symbol : String = "₹"
                            var curCode : String = "INR"
                            let symbolNew = json["currency"].string
                            
                            
                            let msg = json["popupMessage"].string
                            if let popUpMsg = msg, popUpMsg != "" {
                                
                                DispatchQueue.main.async {
                                    self.LoadWebView(popUpMsg)
                                }
                                
                            }else {
                                self.webViewHeightConstraint.constant = 0
                            }
                            
                            
                            if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                
                                print("currency JSON")
                                let currencyJson = try JSON(data: dataFromString)
                                multiplier = Float(currencyJson["Conversion Rate"].stringValue) ?? 0
                                print("multiplier: \(multiplier)")
                                symbol = currencyJson["Symbol"].stringValue
                                curCode = currencyJson["Code"].stringValue
                                
                            }else{
                                print("No values")
                            }
                            
                            //var diagnosisChargeString = Float()
                            var diagnosisChargeString = Int()
                            
                            DispatchQueue.main.async() {
                                
                                if let type = UserDefaults.standard.value(forKey: "storeType") as? Int {
                                    if type == 0 {
                                        //diagnosisChargeString = Float(json["diagnosisCharges"].intValue)
                                        diagnosisChargeString = Int(json["diagnosisCharges"].intValue)
                                    }else {
                                        //diagnosisChargeString = Float(json["pawn"].intValue)
                                        diagnosisChargeString = Int(json["pawn"].intValue)
                                    }
                                }
                                
                                
                                if let online = UserDefaults.standard.value(forKey: "tradeOnline") as? Int {
                                    if online == 0 {
                                        self.btnTradeInOnline.isHidden = true
                                    }else {
                                        self.btnTradeInOnline.isHidden = false
                                    }
                                }
                            }
                            
                            if symbol != symbolNew {
                                //diagnosisChargeString = diagnosisChargeString * multiplier
                                diagnosisChargeString = diagnosisChargeString * Int(multiplier)
                            }
                            
                            //var offer = Float(offerpriceString)!
                            var offer = Int(offerpriceString)!
                            if curCode != symbolNew {
                                //offer = offer * multiplier
                                offer = offer * Int(multiplier)
                            }
                            
                            //let payable = offer - diagnosisChargeString
                            let payable = Int(offer - diagnosisChargeString)
                            print("payable: \(offer - diagnosisChargeString) ")
                            
                            DispatchQueue.main.async() {
                                
                                
                                self.saveResult(price: offerpriceString)
                                
                                if (json["deviceStatusFlag"].exists() && json["deviceStatusFlag"].intValue == 1)
                                {
                                    //self.lblQuoteAmount.text = json["deviceStatus"].stringValue
                                    
                                    self.lblDiagnosisChargeInfo.isHidden = true
                                    self.lblDiagnosisAmount.isHidden = true
                                    
                                    self.lblEstimatedPriceInfo.isHidden = true
                                    self.lblEstimatedAmount.isHidden = true
                                    
                                    
                                    if json["deviceStatus"].stringValue == "" {
                                        self.lblOfferedPriceInfo.isHidden = true
                                        self.lblOfferedAmount.isHidden = true
                                    }
                                    
                                    self.lblOfferedPriceInfo.text = "Device_Status"
                                    self.lblOfferedAmount.text = json["deviceStatus"].stringValue

                                }else{
                                    
                                    //"Offered price " + "\(symbol)\(Int(payable))"
                                    //self.lblQuoteAmount.text = "\(symbol)\(Int(payable))"
                                    
                                    if let type = UserDefaults.standard.value(forKey: "storeType") as? Int {
                                        if type == 0 {
                                            
                                            
                                        }else {
                                            self.lblDiagnosisChargeInfo.text = "Pawn"
                                            self.lblEstimatedPriceInfo.text = "Trade-In"
                                        }
                                    }
                                    
                                    //self.trdValue = String(payable)
                                    //self.trdCurrency = symbol
                                    
                                    // To hide diagnose charges in indonesia
                                    let langStr = Locale.current.languageCode
                                    let pre = Locale.preferredLanguages[0]
                                    print(langStr ?? "",pre)
                                    
                                    
                                    // SAM 18/2/22
                                    // Indonesia
                                    if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                                    
                                        self.trdValue = self.convertIndonesianCurrency(String(payable))
                                        //self.trdCurrency = symbol
                                        self.trdCurrency = symbolNew ?? symbol
                                        
                                    }else {
                                        self.trdValue = String(payable)
                                        //self.trdCurrency = symbol
                                        self.trdCurrency = symbolNew ?? symbol
                                    }
                                    
                                    
                                    
                                    /* // SAM 18/2/22
                                    self.lblEstimatedAmount.text = "\(symbol)\(Int(payable))"
                                    self.lblDiagnosisAmount.text = "\(symbol)\(Int(diagnosisChargeString))"
                                    self.lblOfferedAmount.text = "\(symbol)\(Int(offer))"
                                    */
                                    
                                  
                                    if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                                        
                                        self.diagnoseChargeView.isHidden = true
                                        self.diagnoseChargeInfoView.isHidden = true
                                    }
                                    
                                    
                                    // SAM 18/2/22
                                    // Indonesia
                                    if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                                        
                                       
                                        self.lblEstimatedAmount.text = "\(symbolNew ?? symbol) \(self.convertIndonesianCurrency(String(payable)))"
                                        //self.lblDiagnosisAmount.text = "\(symbolNew)\(Int(diagnosisChargeString))"
                                        self.lblOfferedAmount.text = "\(symbolNew ?? symbol) \(self.convertIndonesianCurrency(String(offer)))"
                                        self.lblTotalAmount.text = "\(symbolNew ?? symbol) \(self.convertIndonesianCurrency(String(payable)))"
                                        
                                    }else {
                                        
                                        self.lblEstimatedAmount.text = "\(symbolNew ?? symbol) \(Int(payable))"
                                        self.lblDiagnosisAmount.text = "\(symbolNew ?? symbol) \(Int(diagnosisChargeString))"
                                        self.lblOfferedAmount.text = "\(symbolNew ?? symbol) \(Int(offer))"
                                        self.lblTotalAmount.text =  "\(symbolNew ?? symbol) \(Int(payable))"
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }else {
                        self.hud.dismiss()
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.hud.dismiss()
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception") )
                }
                
                break
            case .failure(_):
                self.hud.dismiss()
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!") )
                break
            }
      
        }
        
    }
    
    func saveResult(price: String) {
        
        var netType = "Mobile"
        if Luminous.Network.isConnectedViaWiFi {
            netType = "Wifi"
        }
        metaDetails["currentCountry"].string = Luminous.Locale.currentCountry
        metaDetails["Internet  Type"].string = netType
        metaDetails["Internet  SSID"].string = Luminous.Network.SSID
        metaDetails["Internet Availability"].bool = Luminous.Network.isInternetAvailable
        metaDetails["Carrier Name"].string = Luminous.Carrier.name
        metaDetails["Carrier MCC"].string = Luminous.Carrier.mobileCountryCode
        metaDetails["Carrier MNC"].string = Luminous.Carrier.mobileNetworkCode
        metaDetails["Carrier Allows VOIP"].bool = Luminous.Carrier.isVoipAllowed
        metaDetails["GPS Location"].string = Luminous.Locale.currentCountry
        metaDetails["Battery Level"].float = Luminous.Battery.level
        metaDetails["Battery State"].string = "\(Luminous.Battery.state)"
        metaDetails["currentCountry"].string = Luminous.Locale.currentCountry
        
        
        var IMEI = ""
        var productId = ""
        var customerId = ""
        let resultCode = ""
        var devicename = ""
        
        if let imei = AppUserDefaults.value(forKey: "imei_number") as? String {
            IMEI = imei
        }
        
        if let pId = AppUserDefaults.string(forKey: "product_id") {
            productId = pId
        }
        
        if let cId = AppUserDefaults.string(forKey: "customer_id") {
            customerId = cId
        }
        
        if let dName = AppUserDefaults.string(forKey: "productName") {
            devicename = dName
        }
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "customerId" : customerId,
                  "resultCode" : resultCode,
                  "resultJson" : AppResultJSON,
                  "price" : price,
                  "deviceName" : devicename,
                  "conditionString" : AppResultString,
                  "metaDetails" : self.metaDetails,
                  "IMEINumber" : IMEI,
                  "productId" : productId]
        
        print("params = \(params)")
    
        //self.showHudLoader(msg: "")
        
        let webService = AF.request(AppBaseUrl + kSavingResultURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                    
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        let msg = json["msg"]
                        self.currentOrderId = msg["orderId"].string ?? ""
                        
                        DispatchQueue.main.async {
                            self.btnUploadId.isHidden = false
                            self.refValueLabel.isHidden = false
                            self.refValue.isHidden = false
                            
                            let refno = self.getLocalizatioStringValue(key: "Reference No")
                            //self.lblOrderRef.text = "\(refno): \(self.currentOrderId)"
                            
                            self.refValueLabel.text = "\(refno):"
                            self.refValue.text = "\(self.currentOrderId)"
                            
                        }
                        
                        self.showaAlert(message: self.getLocalizatioStringValue(key: "Details Synced to the server. Please contact Store Executive for further information") )
                        
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception") )
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!"))
                break
            }
      
        }
        
    }
    
    func uploadIdProof(photoStr : String) {
        
        var customerId = ""
        if let cId = AppUserDefaults.string(forKey: "customer_id") {
            customerId = cId
        }
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "orderId" : self.currentOrderId,
                  "customerId" : customerId,
                  "photo" : photoStr]
        
        //print("params = \(params)")
    
        self.showHudLoader(msg: self.getLocalizatioStringValue(key: "Uploading...") )
        
        let webService = AF.request(AppBaseUrl + kIdProofURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async() {
                            
                            AppUserDefaults.set(true, forKey: "UploadId")
                            
                            //self.showaAlert(message: self.getLocalizatioStringValue(key: "Photo Id uploaded successfully!"))
                            
                            self.showAlert(title: self.getLocalizatioStringValue(key: "Success") , message: self.getLocalizatioStringValue(key: "Photo Id uploaded successfully!") , alertButtonTitles: [self.getLocalizatioStringValue(key: "Ok")], alertButtonStyles: [.default], vc: self) { index in
                                
                                // To Navigate on End Game Screen
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
                                vc.endGameOrderId = self.currentOrderId
                                vc.endGameValue = self.trdValue
                                vc.tradeCurrency = self.trdCurrency
                                vc.isComeFrom = ""
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true, completion: nil)
                                //self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                        }
                        
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception") )
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!") )
                break
            }
      
        }
        
    }
    
    @IBAction func applyPromoCodeBtnClicked(_ sender: UIButton) {
        
        if sender.titleLabel?.text == self.getLocalizatioStringValue(key: "Have a promo code? Click here").uppercased() {
            
            let alert = UIAlertController(title: self.getLocalizatioStringValue(key: "Apply Promo").uppercased() , message: "", preferredStyle: UIAlertController.Style.alert)
            
            let doneAction = UIAlertAction(title: self.getLocalizatioStringValue(key: "Apply").uppercased() , style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                
                guard !(textField.text?.isEmpty ?? false) else {
                    
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Enter Valid Promo Code") )
                                    
                    return
                }
                
                print(textField.text ?? "nothing")
                print("Promo code applied!")
                self.fireWebServiceForPromoCodeApply(voucher: textField.text ?? "")
                
            }
            
            let cancelAction = UIAlertAction(title: self.getLocalizatioStringValue(key: "Cancel").uppercased(), style: .destructive) { (alertAction) in
                
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = self.getLocalizatioStringValue(key: "Enter Promo code")
            }
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true) {
                
            }
            
        }else {
            
            self.fireWebServiceForRemovePromoCode()
            
        }

    }
    
    func fireWebServiceForPromoCodeApply(voucher: String) {
    
        var parameters = [String : Any]()
        parameters  = [
            "userName" : "planetm",
            "apiKey" : "fd9a42ed13c8b8a27b5ead10d054caaf",
            "cartId" : self.currentOrderId,
            "voucherCode" : voucher
        ]
        
        self.showHudLoader(msg: "")
        
        let webService = AF.request(AppBaseUrl + kCheckTradeinVoucher, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async {
                            
                            self.btnPromoCode.setTitleColor(UIColor.red, for: .normal)
                            self.btnPromoCode.setTitle(self.getLocalizatioStringValue(key: "Remove Promo").uppercased() , for: .normal)
                        
                            //self.lblEstimatedAmount.text = "\(self.trdCurrency)\(json["totalAmount"].int ?? 0)"
                            //self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)\(json["voucherAmount"].string ?? "")"
                            
                            
                            if let strVoucherOrderID = json["voucherOrderId"].string {
                                self.voucherOrderID = strVoucherOrderID
                            }else if let intVoucherOrderID = json["voucherOrderId"].int {
                                self.voucherOrderID = "\(intVoucherOrderID)"
                            }
                            
                            /*
                            if let strVoucher = json["voucherAmount"].string {
                                self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + strVoucher
                            }else if let intVoucher = json["voucherAmount"].int {
                                self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + "\(intVoucher)"
                            }
                            */
                            
                            
                            
                            let langStr = Locale.current.languageCode
                            let pre = Locale.preferredLanguages[0]
                            print(langStr ?? "",pre)
                            
                            // Indonesia
                            if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                                
                                if let totalAMT = json["totalAmount"].string {
                                    let totl = self.convertIndonesianCurrency(totalAMT)
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totl)"
                                    
                                    self.trdValue = totl
                                    
                                }else if let totalAMT = json["totalAmount"].int {
                                    let totl = self.convertIndonesianCurrency(String(totalAMT))
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totl)"
                                    
                                    self.trdValue = totl
                                }
                                
                                
                                if let strVoucher = json["voucherAmount"].string {
                                    let voucherAMT = self.convertIndonesianCurrency(strVoucher)
                                    self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + " \(voucherAMT)"
                                }else if let intVoucher = json["voucherAmount"].int {
                                    let voucherAMT = self.convertIndonesianCurrency(String(intVoucher))
                                    self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + " \(voucherAMT)"
                                }
                                
                            }else {
                                
                                if let totalAMT = json["totalAmount"].string {
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totalAMT)"
                                    
                                    self.trdValue = totalAMT
                                }else if let totalAMT = json["totalAmount"].int {
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totalAMT)"
                                    
                                    self.trdValue = String(totalAMT)
                                }
                                    
                                if let strVoucher = json["voucherAmount"].string {
                                    self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + " " + strVoucher
                                }else if let intVoucher = json["voucherAmount"].int {
                                    self.lblVoucherAmount.text = "+ " + "\(self.trdCurrency)" + " " + "\(intVoucher)"
                                }
                                                            
                            }
                            
                            self.voucherAmountView.isHidden = false
                            self.voucherAmountInfoView.isHidden = false
                            
                            //self.trdValue = "\(json["totalAmount"].int ?? 0)"
                            
                        }
                        
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception") )
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!") )
                break
            }
      
        }
        
    }
    
    func fireWebServiceForRemovePromoCode() {
        
        var parameters = [String : Any]()
        parameters  = [
            "userName" : "planetm",
            "apiKey" : "fd9a42ed13c8b8a27b5ead10d054caaf",
            "voucherOrderId" : self.voucherOrderID
        ]
        
        self.showHudLoader(msg: "")
        
        let webService = AF.request(AppBaseUrl + kRemoveTradeinVoucher, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async {
                        
                            //self.btnPromoCode.setTitleColor(UIColor.init(named: "0b5cc9"), for: .normal)
                            //self.btnPromoCode.setTitle("Apply Promo" , for: .normal)
                            
                            self.btnPromoCode.setTitleColor(UIColor.init(named: "008F00"), for: .normal)
                            self.btnPromoCode.setTitle(self.getLocalizatioStringValue(key: "Have a promo code? Click here").uppercased(), for: .normal)
                            
                            
                            //self.lblEstimatedAmount.text = "\(self.trdCurrency)\(json["totalAmount"].string ?? "")"
                            //self.trdValue = "\(json["totalAmount"].string ?? "")"
                            
                            
                            self.voucherAmountView.isHidden = true
                            self.voucherAmountInfoView.isHidden = true
                            
                            
                            let langStr = Locale.current.languageCode
                            let pre = Locale.preferredLanguages[0]
                            print(langStr ?? "",pre)
                            
                            // Indonesia
                            if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                                
                                if let totalAMT = json["totalAmount"].string {
                                    let totl = self.convertIndonesianCurrency(totalAMT)
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totl)"
                                    
                                    self.trdValue = totl
                                    
                                }else if let totalAMT = json["totalAmount"].int {
                                    let totl = self.convertIndonesianCurrency(String(totalAMT))
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totl)"
                                    
                                    self.trdValue = totl
                                }
                                                                                                                    
                                                                                                                
                            }else {
                                
                                if let totalAMT = json["totalAmount"].string {
                                    
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totalAMT)"
                                    
                                    self.trdValue = totalAMT
                                    
                                }else if let totalAMT = json["totalAmount"].int {
                                    
                                    self.lblTotalAmount.text = "\(self.trdCurrency) \(totalAMT)"
                                    
                                    self.trdValue = String(totalAMT)
                                }
                                                        
                                
                            }
                            
                        }
                        
                    }else {
                        self.showaAlert(message: json["msg"].stringValue)
                    }
                    
                }catch {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "JSON Exception") )
                }
                
                break
            case .failure(_):
                print(responseData.error ?? NSError())
                self.showaAlert(message: self.getLocalizatioStringValue(key: "Something went wrong!!") )
                break
            }
      
        }
        
    }
    
    //MARK:- Tableview Delegates Methods
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if tableView == self.skipTableView {
            //return  self.arrFailedAndSkipedTest.count
        //}else {
            return self.arrQuestion.count
        //}
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        if tableView == self.skipTableView {
            let SkipTestCell = tableView.dequeueReusableCell(withIdentifier: "SkipTestCell", for: indexPath) as! SkipTestCell
            SkipTestCell.lblTestName.text = self.arrFailedAndSkipedTest[indexPath.item].strTestType
           
            return SkipTestCell
            
        }else {*/
        
            let ResultCell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
            ResultCell.lblQuestion.text = self.getLocalizatioStringValue(key: self.arrQuestion[indexPath.item].trimmingCharacters(in: .whitespacesAndNewlines))
            ResultCell.lblAnswer.text = self.getLocalizatioStringValue(key: self.arrAnswer[indexPath.item].trimmingCharacters(in: .whitespacesAndNewlines))
           
            return ResultCell
        //}
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func createTableFromPassFailedTests() {
        
        self.arrFailedAndSkipedTest.removeAll()
        
        if let val = AppUserDefaults.value(forKey: "deadPixel") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Dead Pixels"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "screen") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Screen"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
       
        if let val = AppUserDefaults.value(forKey: "Rotation") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Rotation"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Proximity") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Proximity"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Hardware Buttons") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Hardware Buttons"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Earphone") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Earphone"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "USB") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Charger"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Camera") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Camera"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Autofocus") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Autofocus"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        var biometricTestName = ""
        if BioMetricAuthenticator.canAuthenticate() {
            
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                biometricTestName = "Face-Id Scanner"
            }else {
                biometricTestName = "Fingerprint Scanner"
            }
            
            if let val = AppUserDefaults.value(forKey: "Fingerprint Scanner") as? Bool {
                let model = ModelCompleteDiagnosticFlow()
                model.strTestType = biometricTestName
                
                if !val {
                    self.arrFailedAndSkipedTest.append(model)
                }
            }
           
        }else {
            
            if LocalAuth.shared.hasTouchId() {
                print("Has Touch Id")
            } else if LocalAuth.shared.hasFaceId() {
                print("Has Face Id")
            } else {
                print("Device does not have Biometric Authentication Method")
            }
            
            print("Device does not have Biometric Authentication Method")
            
            biometricTestName = "Biometric Authentication"
            
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = biometricTestName
            self.arrFailedAndSkipedTest.append(model)
            
        }
        
        
        if let val = AppUserDefaults.value(forKey: "WIFI") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "WIFI"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Bluetooth") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Bluetooth"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "GSM") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "GSM"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "GSM") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "SMS Verification"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "GPS") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "GPS"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Microphone") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Microphone"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
             
        if let val = AppUserDefaults.value(forKey: "Speakers") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Speakers"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Vibrator") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Vibrator"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        /*
        if let val = AppUserDefaults.value(forKey: "Torch") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "FlashLight"
            
         if !val {
             self.arrFailedAndSkipedTest.append(model)
         }
        }
        */
        
        if let val = AppUserDefaults.value(forKey: "Storage") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Storage"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if let val = AppUserDefaults.value(forKey: "Battery") as? Bool {
            let model = ModelCompleteDiagnosticFlow()
            model.strTestType = "Battery"
            
            if !val {
                self.arrFailedAndSkipedTest.append(model)
            }
        }
        
        if self.arrFailedAndSkipedTest.count > 0 {
            let testHeight = self.arrFailedAndSkipedTest.count * 35
            print(testHeight)
            //self.skipViewHeightConstraint.constant = CGFloat(200 + testHeight)
        }
        else{
            //self.skipViewTopConstraint.constant = 0
            //self.skipViewHeightConstraint.constant = 0
        }
              
        DispatchQueue.main.async {
            //self.skipTableView.dataSource = self
            //self.skipTableView.delegate = self
            //self.skipTableView.reloadData()
        }
                
    }
    
    //MARK: Custom Methods
    func LoadWebView(_ strHtml : String) {
        webView = self.addWKWebView(viewForWeb: self.baseWebView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //let myURL = URL(string: loadableUrlStr ?? "")
        //let myRequest = URLRequest(url: myURL!)
        //webView.load(myRequest)
        
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        webView.loadHTMLString(headerString + strHtml, baseURL: nil)
        //webView.loadHTMLString(strHtml, baseURL: nil)
        
        //add observer to get estimated progress value
        //self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame.size = viewForWeb.frame.size
        viewForWeb.addSubview(webView)
        return webView
    }
    
    //MARK: WKWebView delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    //self.containerHeight.constant = height as! CGFloat
                    self.webViewHeightConstraint.constant = height as! CGFloat
                    
                    print()
                })
            }
            
        })
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.deviceImageView.image = UIImage(data: data)
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

extension FinalQuoteVC {
    
    func convertIndonesianCurrency(_ currenValue : String) -> String {
        
        var str = currenValue
    
        var arrStr = [String]()
        for _ in str {
            let last3 = String(str.suffix(3))
            let a = str.dropLast(3)
            str = String(a)
            //print(last3)
            
            if last3 != "" {
                arrStr.append(last3)
            }
        }
        
        //print("arrStr 1",arrStr)
        arrStr = arrStr.reversed()
        print("arrStr 2",arrStr)
        
        var finalStr = ""
        for (idn,str) in arrStr.enumerated() {
            if idn == arrStr.count - 1 {
                finalStr = finalStr + str
            }else {
                finalStr = finalStr + str + "."
            }
            print("finalStr is ",finalStr)
        }
        
        return finalStr
    }
}
