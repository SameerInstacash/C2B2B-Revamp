//
//  AppDelegate.swift
//  SmartExchange - Store Trade-in
//
//  Created by Sameer Khan on 05/03/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(2)
        FirebaseApp.configure()
        
        //Intercom.setApiKey("ios_sdk-877b0a9a1daaef87e1fe73862fe33dab0e14912f", forAppId:"nv6ywlh7")
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //MARK: Custom Methods
    
    func navigateToLoginScreen() {
        DispatchQueue.main.async {
            
            self.window = UIWindow(frame:UIScreen.main.bounds)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            if #available(iOS 13.0, *) {
                guard let rootVC = storyboard.instantiateViewController(identifier: "ImeiVC") as? ImeiVC else {
                    print("StoreTokenVC not found")
                    return
                }
                
                let rootNC = UINavigationController(rootViewController: rootVC)
                rootNC.navigationBar.isHidden = true
                self.window?.rootViewController = rootNC
                self.window?.makeKeyAndVisible()
                
            } else {
                // Fallback on earlier versions
                
                let rootVC = storyboard.instantiateViewController(withIdentifier: "ImeiVC") as! ImeiVC
                let rootNC = UINavigationController(rootViewController: rootVC)
                rootNC.navigationBar.isHidden = true
                self.window!.rootViewController = rootNC
                self.window!.makeKeyAndVisible()
                
            }
            
        }
    }

}

