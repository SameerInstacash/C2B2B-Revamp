//
//  ConditionValue.swift
//
//  Created by Sameer Khan on 17/07/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ConditionValue: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kConditionValueValueKey: String = "value"
  private let kConditionValueInternalIdentifierKey: String = "id"
  private let kConditionValueImageKey: String = "image"
  private let kConditionValueAppCodeKey: String = "appCode"

  // MARK: Properties
  public var value: String?
  public var internalIdentifier: String?
  public var image: String?
  public var appCode: String?

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
    value = json[kConditionValueValueKey].string
    internalIdentifier = json[kConditionValueInternalIdentifierKey].string
    image = json[kConditionValueImageKey].string
    appCode = json[kConditionValueAppCodeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = value { dictionary[kConditionValueValueKey] = value }
    if let value = internalIdentifier { dictionary[kConditionValueInternalIdentifierKey] = value }
    if let value = image { dictionary[kConditionValueImageKey] = value }
    if let value = appCode { dictionary[kConditionValueAppCodeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.value = aDecoder.decodeObject(forKey: kConditionValueValueKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kConditionValueInternalIdentifierKey) as? String
    self.image = aDecoder.decodeObject(forKey: kConditionValueImageKey) as? String
    self.appCode = aDecoder.decodeObject(forKey: kConditionValueAppCodeKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(value, forKey: kConditionValueValueKey)
    aCoder.encode(internalIdentifier, forKey: kConditionValueInternalIdentifierKey)
    aCoder.encode(image, forKey: kConditionValueImageKey)
    aCoder.encode(appCode, forKey: kConditionValueAppCodeKey)
  }

}
