//
//  CosmeticQuestions.swift
//
//  Created by Sameer Khan on 17/07/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CosmeticQuestions: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCosmeticQuestionsStatusKey: String = "status"
  private let kCosmeticQuestionsTimeStampKey: String = "timeStamp"
  private let kCosmeticQuestionsMsgKey: String = "msg"

  // MARK: Properties
  public var status: String?
  public var timeStamp: String?
  public var msg: Msg?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    status = json[kCosmeticQuestionsStatusKey].string
    timeStamp = json[kCosmeticQuestionsTimeStampKey].string
    msg = Msg(json: json[kCosmeticQuestionsMsgKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kCosmeticQuestionsStatusKey] = value }
    if let value = timeStamp { dictionary[kCosmeticQuestionsTimeStampKey] = value }
    if let value = msg { dictionary[kCosmeticQuestionsMsgKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kCosmeticQuestionsStatusKey) as? String
    self.timeStamp = aDecoder.decodeObject(forKey: kCosmeticQuestionsTimeStampKey) as? String
    self.msg = aDecoder.decodeObject(forKey: kCosmeticQuestionsMsgKey) as? Msg
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kCosmeticQuestionsStatusKey)
    aCoder.encode(timeStamp, forKey: kCosmeticQuestionsTimeStampKey)
    aCoder.encode(msg, forKey: kCosmeticQuestionsMsgKey)
  }

}
