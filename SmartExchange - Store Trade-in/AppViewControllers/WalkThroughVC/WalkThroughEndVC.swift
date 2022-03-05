//
//  WalkThroughEndVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 16/08/21.
//

import UIKit

class WalkThroughEndVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnGetStart: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIElements()
    }
    
    //MARK:- IBAction
    @IBAction func getStartedBtnPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImeiVC") as! ImeiVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Custom Methods
  
    func setUIElements() {
        self.lblTitle.font = UIFont.init(name: AppRobotoFontMedium, size: 45.0)
        
        self.lblSubTitle.setLineHeight(lineHeight: 3.0)
        self.lblSubTitle.textAlignment = .center
        
        self.btnGetStart.layer.cornerRadius = AppBtnCornerRadius
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
