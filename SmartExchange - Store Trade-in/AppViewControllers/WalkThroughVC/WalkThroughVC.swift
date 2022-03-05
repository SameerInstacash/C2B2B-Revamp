//
//  WalkThroughVC.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 17/08/21.
//

import UIKit

class WalkThroughVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var arrImage = [ #imageLiteral(resourceName: "WT1"), #imageLiteral(resourceName: "WT2"), #imageLiteral(resourceName: "WT3")]
    var arrTitle = ["SCAN STORE CODE","RUN THE TECHCHECK","GET PAID FAST"]
    var arrSubTitle = ["Scan the QR code from the point of sale or enter the store number","Run the diagnostics tests to get the exact value for your device","Hand the phone over to the vendor to verify device and payment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIElements()
    }
    
    //MARK:- IBAction
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalkThroughEndVC") as! WalkThroughEndVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        let visibleItems: NSArray = self.walkThroughCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < self.arrImage.count {
            self.walkThroughCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalkThroughEndVC") as! WalkThroughEndVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK:- Custom Methods
    
    func setUIElements() {
        self.hideKeyboardWhenTappedAroundView()
        self.setStatusBarColor(themeColor: AppThemeColor)
    }
    
    //MARK:- UICollectionView DataSource & Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let WalkThroughCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughCVCell", for: indexPath)
        let iconImageVW: UIImageView = WalkThroughCVCell.viewWithTag(10) as! UIImageView
        let lblTitle: UILabel = WalkThroughCVCell.viewWithTag(20) as! UILabel
        let lblSubTitle: UILabel = WalkThroughCVCell.viewWithTag(30) as! UILabel
        let pageControl: UIPageControl = WalkThroughCVCell.viewWithTag(40) as! UIPageControl
        
        iconImageVW.image = self.arrImage[indexPath.item]
        lblTitle.text = self.arrTitle[indexPath.item]
        lblSubTitle.text = self.arrSubTitle[indexPath.item]
        pageControl.currentPage = indexPath.item
        
        lblTitle.setLineHeight(lineHeight: 3.0)
        lblTitle.textAlignment = .center
        
        lblSubTitle.setLineHeight(lineHeight: 3.0)
        lblSubTitle.textAlignment = .center
        
        lblTitle.font = UIFont.init(name: AppRobotoFontMedium, size: 45.0)
        
        return WalkThroughCVCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        if indexPath.item == (self.arrImage.count - 1) {
            self.btnNext.setTitle("", for: .normal)
            self.btnNext.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
            self.btnSkip.isHidden = true
        }else {
            self.btnNext.setTitle("NEXT", for: .normal)
            self.btnNext.setImage(nil, for: .normal)
            self.btnSkip.isHidden = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.walkThroughCollectionView.bounds.width, height: self.walkThroughCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
