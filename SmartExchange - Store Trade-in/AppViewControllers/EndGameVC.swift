//
//  EndGameVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 16/08/21.
//

import UIKit
import SwiftyJSON

class EndGameVC: UIViewController {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var txtViewMsg: UITextView!
    //@IBOutlet weak var lblNowIsnt: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    var orderId = ""
    
    var endGameOrderId = ""
    var endGameValue = ""
    var tradeCurrency = ""
    var isComeFrom = "TradeIn"
    var str3 = NSAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.gray.cgColor
        
        
        let langStr = Locale.current.languageCode
        let pre = Locale.preferredLanguages[0]
        print(langStr ?? "",pre)
        
        
        // Indonesia
        if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
            
            let a = self.getLocalizatioStringValue(key: "Your Trade-in value is")
            let b = "\n"
            let c = self.tradeCurrency + " "
            //let arr = self.endGameValue.components(separatedBy: ".")
            //let d = arr[0]
            //let e = " richer!"
            //self.lbl1.text = a + b + c + d
            self.lbl1.text = a + b + c + self.endGameValue
            
        }else {
    
            let a = self.getLocalizatioStringValue(key: "Your Trade-in value is")
            let b = "\n"
            let c = self.tradeCurrency + " "
            let arr = self.endGameValue.components(separatedBy: ".")
            let d = arr[0]
            //let e = " richer!"
            self.lbl1.text = a + b + c + d
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Your Trade-in value is Under RM
        
        if isComeFrom == "TradeIn" {
            
            /*
            let a = "Get ready to be "
            let b = self.tradeCurrency + " "
            let arr = self.endGameValue.components(separatedBy: ".")
            let c = arr[0]
            let d = " richer!"
            self.lbl1.text = a + b + c + d
            */
            
            
            let dnd = self.getLocalizatioStringValue(key: "Do not delete")
            let factoryReset = self.getLocalizatioStringValue(key: "Factory Reset")
            
            let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkText,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)] as [NSAttributedString.Key : Any]
            let orderIdAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3349708617, green: 0.6614326835, blue: 0.2838502526, alpha: 1),NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)] as [NSAttributedString.Key : Any]
            
            let str1 = NSAttributedString.init(string: "1) ")
            let str1a = NSAttributedString.init(string: self.getLocalizatioStringValue(key: "Your Order ID is"))
            let str2 = NSAttributedString.init(string:  " " + self.endGameOrderId, attributes: orderIdAttribute)
            let str2a = NSAttributedString.init(string: ".")
            let str2b = NSAttributedString.init(string: "\n2) ")
            let str3a = NSAttributedString.init(string: self.getLocalizatioStringValue(key: "You will be contacted within 24 hours to verify your order and schedule the pick-up."))
            let str4 = NSAttributedString.init(string: "\n3) ")
            let str5 = NSAttributedString.init(string: dnd, attributes: myAttribute)
            
            //let str6 = NSAttributedString.init(string: self.getLocalizatioStringValue(key: " 'SmartExchage Trade-in app' or "))
            
            let str6 = NSAttributedString.init(string: " " + self.getLocalizatioStringValue(key: "'SmartExchage Trade-in app' or") + " ")
            let str7 = NSAttributedString.init(string: factoryReset, attributes: myAttribute)
            let str8 = NSAttributedString.init(string: " " + self.getLocalizatioStringValue(key: "your device before the collection."))
            let str8a = NSAttributedString.init(string: "\n4) ")
            let str9 = NSAttributedString.init(string: self.getLocalizatioStringValue(key: "The final trade-in value will be quoted to you by our logistic personnel."))
            let str9a = NSAttributedString.init(string: "\n5) ")
            let str10 = NSAttributedString.init(string: self.getLocalizatioStringValue(key: "You are only required to erase and remove your passcode and accounts upon agreeing to the final trade-in value."))
            let str11 = NSAttributedString.init(string: "\n6) ")
            let str12 = NSAttributedString.init(string: self.getLocalizatioStringValue(key: "For any queries, please call CompAsia’s hotline at 03-7931 3417 (08:30am-06:00pm Mon - Fri)"))
            
            let combination = NSMutableAttributedString()
            combination.append(str1)
            combination.append(str1a)
            combination.append(str2)
            combination.append(str2a)
            combination.append(str2b)
            combination.append(str3a)
            combination.append(str4)
            combination.append(str5)
            combination.append(str6)
            combination.append(str7)
            combination.append(str8)
            combination.append(str8a)
            combination.append(str9)
            combination.append(str9a)
            combination.append(str10)
            combination.append(str11)
            combination.append(str12)
            
            self.txtViewMsg.textAlignment = .left
            self.txtViewMsg.attributedText = combination
            
        }else {
            
            //self.lbl1.text = ""
            self.txtViewMsg.text = self.getLocalizatioStringValue(key: "Thank you for completing the SmartExchage Trade-in Diagnostic Test. Please walk-in to any SmartExchage stores to finalize your transaction.")
            
        }
        
    }
    
    //MARK:- Custom Methods
    
    func setUIElements() {
        
        self.hideKeyboardWhenTappedAroundView()
        //self.setStatusBarColor(themeColor: AppThemeColor)
        
    }
    
    //MARK:- IBAction
    
    @IBAction func crossBtnPressed(_ sender: UIButton) {
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
