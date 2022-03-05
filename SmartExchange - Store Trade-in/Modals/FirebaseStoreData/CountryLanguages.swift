//
//  CountryLanguages.swift
//  InstaCash
//
//  Created by Sameer Khan on 26/04/21.
//  Copyright © 2021 Prakhar Gupta. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class CountryLanguages: NSObject {
    
    var strLanguageSymbol = ""
    var strLanguageUrl = ""
    var strLanguageName = ""
    var strLanguageVersion = ""
    
    init (countryLanguageSymbol:String,countryLanguageUrl:String, countryLanguageName:String, countryLanguageVersion:String) {
        self.strLanguageSymbol = countryLanguageSymbol
        self.strLanguageUrl = countryLanguageUrl
        self.strLanguageName = countryLanguageName
        self.strLanguageVersion = countryLanguageVersion
    }
    
    init(languageDict: [String: Any]) {
        self.strLanguageSymbol = languageDict["lang_symbole"] as? String ?? ""
        self.strLanguageUrl = languageDict["lang_url"] as? String ?? ""
        self.strLanguageName = languageDict["name"] as? String ?? ""
        self.strLanguageVersion = languageDict["version"] as? String ?? ""
    }
    
    static func fetchLanguageFromFireBase(isInterNet:Bool, getController:UIViewController, completion: @escaping ([CountryLanguages]) -> Void ) {
        
        let ref = Database.database().reference(withPath: "language_strings")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let tempArr = snapshot.value as! NSArray
            var languageList = [CountryLanguages]()

            for index in 0..<tempArr.count {

                let dict = tempArr[index] as! NSDictionary
                //if dict.value(forKey: "isEnabled") as! Bool == true {
                    let memberItem = CountryLanguages(languageDict: dict as! [String : Any])
                    languageList.append(memberItem)
                //}
            }
            
            DispatchQueue.main.async {
                completion(languageList)
            }
            
        })
        
        /*
        // Sameer 19/7/21 --> To Reflect the realTime Changes in Firebase database
        
        ref.observe(DataEventType.childChanged, with: { (snapshot) in
          let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            DispatchQueue.main.async {
                print(postDict)
                                        
                    if CustomUserDefault.getCountryLanguageName() == postDict["name"] as? String {
                        
                        if CustomUserDefault.getCountryLanguageVersion() != postDict["version"] as? String {
                            DispatchQueue.main.async {
                                if let url = postDict["lang_url"] as? String {
                                    self.downloadSelectedLanguageInBackground(url)
                                    
                                    //save here language details
                                    CustomUserDefault.setCountryLanguageName(data: postDict["name"] as? String ?? "")
                                    CustomUserDefault.setCountryLanguageVersion(data: postDict["version"] as? String ?? "")
                                    
                                }
                            }
                        }
                        
                    }
                                
            }
            
        })
        */
        
        
    }
    
    
    static func downloadSelectedLanguageInBackground(_ strUrl : String) {
        
        DispatchQueue.main.async {
            
            let url:URL = URL(string: strUrl)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? NSDictionary {
                        
                        print(json)
                        
                        DispatchQueue.main.async {
                            //CustomUserDefault.setCountryLanguage(data: json)
                        }
                    }
                    
                } catch {
                    print("JSON serialization failed: ", error)
                }
                
            })
            task.resume()
        }
        
        
    }
    
}
