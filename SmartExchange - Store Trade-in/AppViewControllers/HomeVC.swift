//
//  HomeVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 13/07/21.
//

import UIKit
import AlamofireImage

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var lblDeviceBrand: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var isVietnamese = false
    
    var isPriceShow = false
    var currencySymbol = ""
    var currentPrice = ""
    
    let arrIcon = [#imageLiteral(resourceName: "icon_wifi"),#imageLiteral(resourceName: "icon_sim"),#imageLiteral(resourceName: "icon_fingerprint"),#imageLiteral(resourceName: "icon_nfc"),#imageLiteral(resourceName: "icon_rotation"),#imageLiteral(resourceName: "silentMode"),#imageLiteral(resourceName: "icon_bluetooth"),#imageLiteral(resourceName: "regionCode")]
    var arrIconName = ["Connect to Wifi/Internet","Active Sim Card","Set up Fingerprint (if applicable)","Enable NFC (if applicable)","Enable Auto-Rotate Screen","Disable Silent Mode","Enable bluetooth","Ensure device region code is not LL"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDeviceData()
        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    //MARK:- IBAction
    @IBAction func startBtnPressed(_ sender: UIButton) {
        self.DeadPixelTest()
        
        //self.TestResultScreen()
    }
    
    //MARK:- Custom Methods
  
    func setUIElements() {
        
        self.lblWelcome.text = self.getLocalizatioStringValue(key: "Welcome to SmartExchange")
        self.btnStart.setTitle(self.getLocalizatioStringValue(key: "Let's Get Started").uppercased(), for: .normal)
        
        self.setStatusBarColor(themeColor: AppThemeColor)
        
        self.deviceView.layer.cornerRadius = AppBtnCornerRadius
        self.iconCollectionView.layer.cornerRadius = AppBtnCornerRadius
        self.btnStart.layer.cornerRadius = AppBtnCornerRadius
        
        let langStr = Locale.current.languageCode
        let pre = Locale.preferredLanguages[0]
        print(langStr ?? "",pre)
        
        if isPriceShow {
            
            self.lblPrice.isHidden = false
            //self.lblPrice.text = "Get Upto" + ":" + " "+self.currencySymbol + " "+self.currentPrice
            
            if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "ID") || langStr == "id" || UserDefaults.standard.value(forKey: "currentCountry") as? String == "ID" {
                
                var str = self.currentPrice
                //var str = "50000000"
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
                    self.lblPrice.text = self.getLocalizatioStringValue(key: "Get Upto") + ":" + " " + self.currencySymbol + " " + "\(finalStr)"
                }
                
                
                //let intVal = Int(self.currentPrice)
                //let intPrice = intVal?.formattedWithSeparator
                //print("intVal is:",intVal ?? "", "intPrice is:", intPrice ?? "")
                //self.lblPrice.text = "Get Upto" + ":" + " "+self.currencySymbol + " "+"\(intPrice ?? "")"
                
            }
            
        }else {
            self.lblPrice.isHidden = true
        }
        
        if (UserDefaults.standard.value(forKey: "SelectedLanguageSymbol") as? String == "VI") || langStr == "vi" {
            self.infoLabel.text = "Hãy làm các bước dưới đây \n trước khi bắt đầu:"
            self.isVietnamese = true
        } else {
            self.infoLabel.text = ""
            self.isVietnamese = false
            
            
            let isHide = UserDefaults.standard.bool(forKey: "LL_Region_hide")
            if isHide {
                self.isVietnamese = true
            }else {
                self.isVietnamese = false
            }
            
        }
        
    }
    
    func setDeviceData() {
                
        if let pBrand = AppUserDefaults.string(forKey: "product_brand") {
            self.lblDeviceBrand.text = pBrand
        }else {
            self.lblDeviceBrand.text = "Apple"
        }
        
        if let pName = AppUserDefaults.string(forKey: "productName") {
            //self.lblDeviceName.text = pName.replacingOccurrences(of: "Apple ", with: "")
            self.lblDeviceName.text = pName
        }else {
            self.lblDeviceName.text = ""
        }
        
        if let pImage = AppUserDefaults.string(forKey: "productImage") {
            if let imgUrl = URL(string: pImage) {
                self.deviceImageView.af.setImage(withURL: imgUrl)
            }
        }
    }
    
    // MARK: - UICollectionView DataSource & Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.arrIcon.count
        
        if self.isVietnamese {
            return self.arrIcon.count - 1
        }else {
            return self.arrIcon.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
        let iconImgView : UIImageView = iconCell.viewWithTag(10) as! UIImageView
        let lblIconName : UILabel = iconCell.viewWithTag(20) as! UILabel
        
        iconImgView.image = self.arrIcon[indexPath.item]
        lblIconName.text = self.getLocalizatioStringValue(key: self.arrIconName[indexPath.item])
       
        return iconCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize.init(width: self.iconCollectionView.bounds.width/2 - 2, height: self.iconCollectionView.bounds.width/2 - 2)
        
        if UIDevice.current.model.hasPrefix("iPad") {
            
            let size = CGSize.init(width: self.iconCollectionView.bounds.width/3 - 2, height: self.iconCollectionView.bounds.width/3 - 3)
            return size
        }else {
            
            let size = CGSize.init(width: self.iconCollectionView.bounds.width/2 - 2, height: self.iconCollectionView.bounds.width/2 - 2)
            return size
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension HomeVC {
    
    func DeadPixelTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "DeadPixelsVC") as! DeadPixelsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .flipHorizontal
        
        vc.deadPixelTestDiagnosis = {
            DispatchQueue.main.async() {
                self.touchScreenTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func touchScreenTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ScreenCalibrationVC") as! ScreenCalibrationVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.screenTestDiagnosis = {
            DispatchQueue.main.async() {
                self.AutoRotationTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func AutoRotationTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "AutoRotationVC") as! AutoRotationVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.rotationTestDiagnosis = {
            DispatchQueue.main.async() {
                self.ProximityTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func ProximityTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ProximityVC") as! ProximityVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.proximityTestDiagnosis = {
            DispatchQueue.main.async() {
                self.VolumeButtonTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func VolumeButtonTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "VolumeButtonVC") as! VolumeButtonVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.volumeTestDiagnosis = {
            DispatchQueue.main.async() {
                
                switch UIDevice.current.currentModelName {
                case "iPhone 4","iPhone 4s","iPhone 5","iPhone 5c","iPhone 5s","iPhone 6","iPhone 6 Plus","iPhone 6s","iPhone 6s Plus":
                                
                    //self.EarphoneTest()
                    self.CameraTest()
                    break
                default:
                    
                    //self.ChargerTest()
                    self.CameraTest()
                    break
                }
                
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func EarphoneTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "EarphoneVC") as! EarphoneVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.earphoneTestDiagnosis = {
            DispatchQueue.main.async() {
                self.ChargerTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func ChargerTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "ChargerVC") as! ChargerVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.chargerTestDiagnosis = {
            DispatchQueue.main.async() {
                self.CameraTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func CameraTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.cameraTestDiagnosis = {
            DispatchQueue.main.async() {
                self.BiometricTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func BiometricTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BiometricVC") as! BiometricVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.biometricTestDiagnosis = {
            DispatchQueue.main.async() {
                self.WiFiTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func WiFiTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "WiFiVC") as! WiFiVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.wifiTestDiagnosis = {
            DispatchQueue.main.async() {
                self.BackgroundTest()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func BackgroundTest() {
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "BackgroundTestsVC") as! BackgroundTestsVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.backgroundTestDiagnosis = {
            DispatchQueue.main.async() {
                self.TestResultScreen()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func TestResultScreen() {
        
        let vc = UIStoryboard(name: "InstaCash", bundle: nil).instantiateViewController(withIdentifier: "DiagnosticTestResultVC") as! DiagnosticTestResultVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.testResultTestDiagnosis = {
            DispatchQueue.main.async() {
                print(AppResultJSON)
                print(AppResultString)
                
                self.CosmeticHardwareQuestions()
            }
        }
        self.present(vc, animated: true, completion: nil)
                
    }
    
    func CosmeticHardwareQuestions() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CosmeticQuestionsVC1") as! CosmeticQuestionsVC1
        
        hardwareQuestionsCount -= 1
        AppQuestionIndex += 1
        
        // To Handle forward case
        vc.TestDiagnosisForward = {
            DispatchQueue.main.async() {
               
                if hardwareQuestionsCount > 0 {
                    self.CosmeticHardwareQuestions()
                }else {
                    
                    for appCode in arrAppQuestionsAppCodes ?? [] {
                        AppResultString = AppResultString + appCode + ";"
                        print("AppResultString is :", AppResultString)
                    }
                                        
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        
        vc.modalPresentationStyle = .overFullScreen
        
        if arrAppHardwareQuestions?[AppQuestionIndex].isInput == "1" {
            vc.arrQuestionAnswer = arrAppHardwareQuestions?[AppQuestionIndex]
            self.present(vc, animated: true, completion: nil)
        }else {
            self.CosmeticHardwareQuestions()
        }
           
        /*
        if AppHardwareQuestionsData?.msg?.questions?[AppQuestionIndex].isInput == "1" {
            vc.arrQuestionAnswer = AppHardwareQuestionsData?.msg?.questions?[AppQuestionIndex]
            self.present(vc, animated: true, completion: nil)
        }else {
            self.CosmeticHardwareQuestions()
        }
        */
                
    }


}
