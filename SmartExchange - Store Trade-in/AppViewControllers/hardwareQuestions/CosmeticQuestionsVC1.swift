//
//  CosmeticQuestionsVC1.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 14/07/21.
//

import UIKit
import AlamofireImage

class CosmeticQuestionsVC1: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var arrQuestionAnswer : Questions?
    var TestDiagnosisForward: (() -> Void)?
    var selectedAppCode = ""
    var selectedCellIndex = -1
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestionName: UILabel!
    @IBOutlet weak var cosmeticCollectionView: UICollectionView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AppQuestionIndex == 0 {
            self.btnPrevious.isHidden = true
        }else {
            self.btnPrevious.isHidden = false
        }
        
        if (self.arrQuestionAnswer?.specificationValue?.count ?? 0) > 0 {
            //self.lblQuestionName.text = arrQuestionAnswer?.specificationName
            self.lblQuestionName.text = self.getLocalizatioStringValue(key: arrQuestionAnswer?.specificationName ?? "")
            
        }else {
            //self.lblQuestionName.text = arrQuestionAnswer?.conditionSubHead
            self.lblQuestionName.text = self.getLocalizatioStringValue(key: arrQuestionAnswer?.conditionSubHead ?? "")
        }
      
    }
    
    //MARK:- IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func previousBtnPressed(_ sender: UIButton) {
        
        arrAppQuestionsAppCodes?.remove(at: AppQuestionIndex-1)
        print("arrQuestionsAppCodes are :", arrAppQuestionsAppCodes ?? [])
        
        hardwareQuestionsCount += 2
        AppQuestionIndex -= 2
        
        
        guard let didFinishRetryDiagnosis = self.TestDiagnosisForward else { return }
        didFinishRetryDiagnosis()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func continueBtnPressed(_ sender: UIButton) {
        
        if self.selectedAppCode == "" {
            self.showaAlert(message: self.getLocalizatioStringValue(key: "Please select one option"))
        }else {
            
            arrAppQuestionsAppCodes?.append(self.selectedAppCode)
            print("arrQuestionsAppCodes are :", arrAppQuestionsAppCodes ?? [])
            
            // 14/3/22
            //AppResultString = AppResultString + self.selectedAppCode + ";"
            
            guard let didFinishRetryDiagnosis = self.TestDiagnosisForward else { return }
            didFinishRetryDiagnosis()
            self.dismiss(animated: false, completion: nil)
        }
                
    }
    
    //MARK:- Custom Methods
  
    func setUIElements() {
        
        self.lblTitle.text = self.getLocalizatioStringValue(key: "Physical Condition")
        self.btnContinue.setTitle(self.getLocalizatioStringValue(key: "Continue").uppercased(), for: .normal)
        self.btnPrevious.setTitle(self.getLocalizatioStringValue(key: "Previous").uppercased(), for: .normal)
        
        self.setStatusBarColor(themeColor: AppThemeColor)
        self.btnContinue.layer.cornerRadius = AppBtnCornerRadius
    }
    
    // MARK: - UICollectionView DataSource & Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.arrQuestionAnswer?.specificationValue?.count ?? 0) > 0 {
            return self.arrQuestionAnswer?.specificationValue?.count ?? 0
        }else {
            return self.arrQuestionAnswer?.conditionValue?.count ?? 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cosmeticCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cosmeticCell1", for: indexPath)
        cosmeticCell1.layer.cornerRadius = AppBtnCornerRadius
        
        let iconImgView : UIImageView = cosmeticCell1.viewWithTag(10) as! UIImageView
        let lblIconName : UILabel = cosmeticCell1.viewWithTag(20) as! UILabel
        
        if (self.arrQuestionAnswer?.specificationValue?.count ?? 0) > 0 {
            let answer = self.arrQuestionAnswer?.specificationValue?[indexPath.item]
            
            //let str = answer?.value?.removingPercentEncoding
            let str = self.getLocalizatioStringValue(key: answer?.value?.removingPercentEncoding ?? "")
            //print("str 1 is", str)
            //print("str 11 is", answer?.value ?? "answer?.value")
            lblIconName.text = str.replacingOccurrences(of: "+", with: " ")
            
            if let qImage = self.arrQuestionAnswer?.specificationValue?[indexPath.item].image {
                if let imgUrl = URL(string: qImage) {
                    iconImgView.af.setImage(withURL: imgUrl)
                }
            }
            
            
        }else {
            let answer = self.arrQuestionAnswer?.conditionValue?[indexPath.item]
            
            //let str = answer?.value?.removingPercentEncoding
            let str = self.getLocalizatioStringValue(key: answer?.value?.removingPercentEncoding ?? "")
            //print("str 2 is", str)
            //print("str 22 is", answer?.value ?? "answer?.value")
            lblIconName.text = str.replacingOccurrences(of: "+", with: " ")
            
            if let qImage = self.arrQuestionAnswer?.conditionValue?[indexPath.item].image {
                if let imgUrl = URL(string: qImage) {
                    iconImgView.af.setImage(withURL: imgUrl)
                }
            }
         
        }
        
        
        if self.selectedCellIndex == indexPath.item {
            cosmeticCell1.layer.borderWidth = 1.0
            cosmeticCell1.layer.borderColor = AppThemeColor.cgColor
        }else {
            cosmeticCell1.layer.borderWidth = 0.0
            cosmeticCell1.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cosmeticCell1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (self.arrQuestionAnswer?.specificationValue?.count ?? 0) > 0 {
            self.selectedAppCode = self.arrQuestionAnswer?.specificationValue?[indexPath.item].appCode ?? ""
        }else {
            self.selectedAppCode = self.arrQuestionAnswer?.conditionValue?[indexPath.item].appCode ?? ""
        }
        
        print("self.selectedAppCode is:-", self.selectedAppCode)
        
        self.selectedCellIndex = indexPath.item
        self.cosmeticCollectionView.reloadData()
        
        /* 14/3/22
        AppResultString = AppResultString + self.selectedAppCode + ";"
        
        guard let didFinishRetryDiagnosis = self.TestDiagnosisForward else { return }
        didFinishRetryDiagnosis()
        self.dismiss(animated: false, completion: nil)
        */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.cosmeticCollectionView.bounds.width/2 - 10, height: self.cosmeticCollectionView.bounds.width/2 - 10)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
