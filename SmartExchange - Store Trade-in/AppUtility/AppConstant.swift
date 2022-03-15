//
//  AppConstant.swift
//  InstaCashApp
//
//  Created by Sameer Khan on 06/07/21.
//

import UIKit
import SwiftyJSON

//var AppdidFinishTestDiagnosis: (() -> Void)?
//var AppdidFinishRetryDiagnosis: (() -> Void)?

//var AppBaseUrl = "https://exuat.reboxed.co/api/v1/public/"
var AppBaseUrl = ""
var AppUserName = "planetm"
var AppApiKey = "fd9a42ed13c8b8a27b5ead10d054caaf"

var arrCountrylanguages = [CountryLanguages]()

// Api Name
let kStartSessionURL = "startSession"
let kGetProductDetailURL = "getProductDetail"
let kUpdateCustomerURL = "updateCustomer"
let kGetSessionIdbyIMEIURL = "getSessionIdbyIMEI"
let kPriceCalcNewURL = "priceCalcNew"
let kSavingResultURL = "savingResult"
let kIdProofURL = "idProof"
let kgetMaxisForm = "getMaxisForm"
let ksetMaxisForm = "setMaxisForm"
let kCheckTradeinVoucher = "checkTradeinVoucher"
let kRemoveTradeinVoucher = "removeTradeinVoucher"

var AppCurrentProductBrand = ""
var AppCurrentProductName = ""
var AppCurrentProductImage = ""

var hardwareQuestionsCount = 0
var AppQuestionIndex = -1

var AppHardwareQuestionsData : CosmeticQuestions?
var arrAppHardwareQuestions: [Questions]?
var arrAppQuestionsAppCodes : [String]?

// ***** App Theme Color ***** //
var AppThemeColorHexString : String?
var AppThemeColor : UIColor = UIColor().HexToColor(hexString: AppThemeColorHexString ?? "#008F00", alpha: 1.0)

// ***** Font-Family ***** //
var AppFontFamilyName : String?

var AppRobotoFontRegular = "\(AppFontFamilyName ?? "Roboto")-Regular"
var AppRobotoFontMedium = "\(AppFontFamilyName ?? "Roboto")-Medium"
var AppRobotoFontBold = "\(AppFontFamilyName ?? "Roboto")-Bold"

//var AppBrownFontRegular = "\(AppFontFamilyName ?? "Brown")-Regular"
//var AppBrownFontBold = "\(AppFontFamilyName ?? "Brown")-Bold"

//var AppSupplyFontRegular = "\(AppFontFamilyName ?? "Supply")-Regular"
//var AppSupplyFontMedium = "\(AppFontFamilyName ?? "Supply")-Medium"
//var AppSupplyFontBold = "\(AppFontFamilyName ?? "Supply")-Bold"

//var AppDrukFontMedium = "\(AppFontFamilyName ?? "Druk")-Medium"
//var AppDrukFontBold = "\(AppFontFamilyName ?? "Druk")-Bold"

// ***** Button Properties ***** //
var AppBtnCornerRadius : CGFloat = 10
var AppBtnTitleColorHexString : String?
var AppBtnTitleColor : UIColor = UIColor().HexToColor(hexString: AppBtnTitleColorHexString ?? "#FFFFFF", alpha: 1.0)

// ***** App Tests Performance ***** //
var holdAppTestsPerformArray = [String]()
var AppTestsPerformArray = [String]()
var AppTestIndex : Int = 0

let AppUserDefaults = UserDefaults.standard
var AppResultJSON = JSON()
var AppResultString = ""

var AppOrientationLock = UIInterfaceOrientationMask.all

var AppLicenseKey : String?
//var AppUserName : String?
//var AppApiKey : String?
var AppUrl : String?
var AppLastAdded : String?
var AppLicenseLeft : Int?
var AppLicenseConsumed : Int?
var AppResultApplicableTill : Int?
var AppResumeTestApplicableTill : Int?

var App_AssistedIsEnable : Bool?
var App_AssistedApplicableTill : Int?
var App_AutomatedIsEnable : Bool?
var App_AutomatedApplicableTill : Int?
var App_PhysicalIsEnable : Bool?
var App_PhysicalApplicableTill : Int?

