//
//  SpecificationValue.swift
//
//  Created by Sameer Khan on 17/07/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SpecificationValue: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSpecificationValueValueKey: String = "value"
  private let kSpecificationValueInternalIdentifierKey: String = "id"
  private let kSpecificationValueImageKey: String = "image"
  private let kSpecificationValueAppCodeKey: String = "appCode"

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
    value = json[kSpecificationValueValueKey].string
    internalIdentifier = json[kSpecificationValueInternalIdentifierKey].string
    image = json[kSpecificationValueImageKey].string
    appCode = json[kSpecificationValueAppCodeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = value { dictionary[kSpecificationValueValueKey] = value }
    if let value = internalIdentifier { dictionary[kSpecificationValueInternalIdentifierKey] = value }
    if let value = image { dictionary[kSpecificationValueImageKey] = value }
    if let value = appCode { dictionary[kSpecificationValueAppCodeKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.value = aDecoder.decodeObject(forKey: kSpecificationValueValueKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kSpecificationValueInternalIdentifierKey) as? String
    self.image = aDecoder.decodeObject(forKey: kSpecificationValueImageKey) as? String
    self.appCode = aDecoder.decodeObject(forKey: kSpecificationValueAppCodeKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(value, forKey: kSpecificationValueValueKey)
    aCoder.encode(internalIdentifier, forKey: kSpecificationValueInternalIdentifierKey)
    aCoder.encode(image, forKey: kSpecificationValueImageKey)
    aCoder.encode(appCode, forKey: kSpecificationValueAppCodeKey)
  }

}
