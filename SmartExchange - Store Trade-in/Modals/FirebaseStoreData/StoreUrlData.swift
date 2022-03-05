//
//  StoreUrlData.swift
//  SmartExchange
//
//  Created by Sameer Khan on 10/06/21.
//  Copyright © 2021 ZeroWaste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class StoreUrlData: NSObject {
    
    var strCountry = ""
    var strIsTradeOnline = 0
    var strPrefixKey = ""
    var strProgram = ""
    var strTnc = ""
    var strType = 0
    var strUrl = ""
    var strIsPriceShow = 0
    var strIsVoucherEnable = 0
    
    init (country:String, trade:Int, prefix:String, program:String, tnc:String, type:Int, url:String, isPshow:Int, voucherEnable: Int) {
        self.strCountry = country
        self.strIsTradeOnline = trade
        self.strPrefixKey = prefix
        self.strProgram = program
        self.strTnc  = tnc
        self.strType = type
        self.strUrl = url
        self.strIsPriceShow = isPshow
        self.strIsVoucherEnable = voucherEnable
    }
    
    init(storeUrlDict: [String: Any]) {
        
        self.strCountry = storeUrlDict["country"] as? String ?? ""
        self.strIsTradeOnline = storeUrlDict["isTradeOnline"] as? Int ?? 0
        self.strPrefixKey = storeUrlDict["prefixKey"] as? String ?? ""
        self.strProgram = storeUrlDict["program"] as? String ?? ""
        self.strTnc = storeUrlDict["tnc"] as? String ?? ""
        self.strType = storeUrlDict["type"] as? Int ?? 0
        self.strUrl = storeUrlDict["url"] as? String ?? ""
        self.strIsPriceShow = storeUrlDict["isPriceShow"] as? Int ?? 0
        self.strIsVoucherEnable = storeUrlDict["isVoucherEnable"] as? Int ?? 0
        
    }
    
    static func fetchStoreUrlsFromFireBase(isInterNet:Bool, getController:UIViewController, completion: @escaping ([StoreUrlData]) -> Void ) {
                
        let ref = Database.database().reference(withPath: "store_url")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let tempArr = snapshot.value as! NSArray
            var storeList = [StoreUrlData]()

            for index in 0..<tempArr.count {

                if let dict = tempArr[index] as? NSDictionary {
                    let memberItem = StoreUrlData(storeUrlDict: dict as! [String : Any])
                    storeList.append(memberItem)
                }
                
            }
            
            DispatchQueue.main.async {
                completion(storeList)
            }
            
        })
        
    }
    
    
}
