//
//  QuoteDetailVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 20/07/21.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftyJSON
import DKCamera

class QuoteDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var lblOrderDetail: UILabel!
    @IBOutlet weak var lblReferenceIdTitle: UILabel!
    @IBOutlet weak var lblReferenceId: UILabel!
    @IBOutlet weak var lblPrefferredTimeTitle: UILabel!
    @IBOutlet weak var lblPrefferredTime: UILabel!
    @IBOutlet weak var lblCustomerTitle: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblFunctionalChecks: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnUploadId: UIButton!
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var quoteTableViewHeightConstraint: NSLayoutConstraint!

    var QuoteJSON = JSON()
    let hud = JGProgressHUD()
    var orderId = ""
    let reachability: Reachability? = Reachability()
    var arrQuestion = [String]()
    var arrAnswer = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.setUIElements()
            self.showQuote()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.quoteTableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
        self.quoteTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.quoteTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                self.quoteTableViewHeightConstraint.constant = newsize.height + 0.0
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backHomePressed(_ sender: UIButton) {
        
        AppResultJSON = JSON()
        AppResultString = ""
        AppHardwareQuestionsData = nil
        hardwareQuestionsCount = 0
        AppQuestionIndex = -1
        self.resetAppUserDefaults()

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
                                
                if self.reachability?.connection.description != "No Connection" {
                    self.uploadIdProof(photoStr: strBase64)
                }else {
                    self.showaAlert(message: self.getLocalizatioStringValue(key: "Please Check Internet connection."))
                }
                
            }
            
        }
        
        self.present(camera, animated: true, completion: nil)
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
        
        self.lblTitle.text = self.getLocalizatioStringValue(key: "SMART EXCHANGE")
        self.lblOrderDetail.text = self.getLocalizatioStringValue(key: "Order details")
        self.lblReferenceIdTitle.text = self.getLocalizatioStringValue(key: "Reference No")
        self.lblCustomerTitle.text = self.getLocalizatioStringValue(key: "Customer")
        self.lblPrefferredTimeTitle.text = self.getLocalizatioStringValue(key: "Prefferred time")
        self.lblEmailTitle.text = self.getLocalizatioStringValue(key: "Email")
        self.lblFunctionalChecks.text = self.getLocalizatioStringValue(key: "Functional Checks")
        self.btnHome.setTitle(self.getLocalizatioStringValue(key: "Home").uppercased(), for: .normal)
        
        self.hideKeyboardWhenTappedAroundView()
        self.setStatusBarColor(themeColor: AppThemeColor)
        
        self.deviceView.layer.cornerRadius = AppBtnCornerRadius
        self.quoteTableView.layer.cornerRadius = AppBtnCornerRadius
        self.btnUploadId.layer.cornerRadius = AppBtnCornerRadius
      
    }
    
    func showQuote() {
        
        DispatchQueue.main.async() {
            
            let json = self.QuoteJSON
            let msg = json["msg"]
                       
            if let name = msg["name"].string {
                self.lblCustomerName.text = name
            }else {
                self.lblCustomerName.text = ""
            }
            
            if let mail = msg["email"].string {
                self.lblEmail.text = mail
            }else {
                self.lblEmail.text = ""
            }
            
            /*
            if let mobile = msg["mobileNumber"].string {
                self.lblContactNum.text = mobile
            }else {
                self.lblContactNum.text = ""
            }
            */
            
            if let id = msg["id"].string {
                self.lblReferenceId.text = id
            }else {
                self.lblReferenceId.text = ""
            }
            
            if let time = msg["scheduleDateTime"].string {
                self.lblPrefferredTime.text = time
            }else {
                self.lblPrefferredTime.text = ""
            }
                                        
            
            DispatchQueue.main.async {
                
                let finalSummaryText = msg["productDescription"].stringValue
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
                        //self.arrQuestion.append(arrItem[0])
                        //self.arrAnswer.append(arrItem[1])
                        
                        self.arrQuestion.append(self.getLocalizatioStringValue(key: arrItem[0]))
                        self.arrAnswer.append(self.getLocalizatioStringValue(key: arrItem[1]))
                        
                    }else {
                        let pre = self.arrAnswer.last
                        //let val = (pre ?? "") + " & " + arrItem[0]
                        
                        let val = self.getLocalizatioStringValue(key: (pre ?? "")) + " & " + self.getLocalizatioStringValue(key: arrItem[0])
                        let key = self.arrQuestion.last
                        
                        self.arrQuestion.removeLast()
                        self.arrAnswer.removeLast()
                        
                        self.arrQuestion.append(key ?? "")
                        self.arrAnswer.append(val)
                    }
                }
                
                self.arrQuestion.insert(self.getLocalizatioStringValue(key: "Functionality"), at: 0)
                self.arrAnswer.insert(self.getLocalizatioStringValue(key: "Condition"), at: 0)
                
                self.quoteTableView.dataSource = self
                self.quoteTableView.delegate = self
                self.quoteTableView.reloadData()
                
            }
            
        }
        
    }
    
    //MARK:- Web Service Methods
    func showHudLoader(msg : String) {
        hud.textLabel.text = msg
        hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
    }
    
    func uploadIdProof(photoStr : String) {
        
        var customerId = ""
        if let cId = AppUserDefaults.string(forKey: "customer_id") {
            customerId = cId
        }
        
        var params = [String : Any]()
        params = ["userName" : AppUserName,
                  "apiKey" : AppApiKey,
                  "orderId" : self.orderId,
                  "customerId" : customerId,
                  "photo" : photoStr]
        
        //print("params = \(params)")
    
        self.showHudLoader(msg: self.getLocalizatioStringValue(key: "Uploading..."))
        
        let webService = AF.request(AppBaseUrl + kIdProofURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil, requestModifier: nil)
        webService.responseJSON { (responseData) in
            
            self.hud.dismiss()
            //print(responseData.value as? [String:Any] ?? [:])
            
            switch responseData.result {
            case .success(_):
                                
                do {
                    let json = try JSON(data: responseData.data ?? Data())
                    
                    if json["status"] == "Success" {
                        
                        DispatchQueue.main.async() {
                            self.showaAlert(message: self.getLocalizatioStringValue(key: "Photo Id uploaded successfully!"))
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
    
    //MARK:- Tableview Delegates Methods
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrQuestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ResultCell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        ResultCell.lblQuestion.text = self.getLocalizatioStringValue(key: self.arrQuestion[indexPath.item].trimmingCharacters(in: .whitespacesAndNewlines))
        ResultCell.lblAnswer.text = self.getLocalizatioStringValue(key: self.arrAnswer[indexPath.item].trimmingCharacters(in: .whitespacesAndNewlines))
        
        return ResultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
