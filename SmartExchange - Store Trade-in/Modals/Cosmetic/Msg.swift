//
//  Msg.swift
//
//  Created by Sameer Khan on 17/07/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Msg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMsgNameKey: String = "name"
  private let kMsgInternalIdentifierKey: String = "id"
  private let kMsgImageKey: String = "image"
  private let kMsgBasePriceKey: String = "basePrice"
  private let kMsgQuestionsKey: String = "questions"

  // MARK: Properties
  public var name: String?
  public var internalIdentifier: String?
  public var image: String?
  public var basePrice: String?
  public var questions: [Questions]?

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
    name = json[kMsgNameKey].string
    internalIdentifier = json[kMsgInternalIdentifierKey].string
    image = json[kMsgImageKey].string
    basePrice = json[kMsgBasePriceKey].string
    if let items = json[kMsgQuestionsKey].array { questions = items.map { Questions(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kMsgNameKey] = value }
    if let value = internalIdentifier { dictionary[kMsgInternalIdentifierKey] = value }
    if let value = image { dictionary[kMsgImageKey] = value }
    if let value = basePrice { dictionary[kMsgBasePriceKey] = value }
    if let value = questions { dictionary[kMsgQuestionsKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: kMsgNameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kMsgInternalIdentifierKey) as? String
    self.image = aDecoder.decodeObject(forKey: kMsgImageKey) as? String
    self.basePrice = aDecoder.decodeObject(forKey: kMsgBasePriceKey) as? String
    self.questions = aDecoder.decodeObject(forKey: kMsgQuestionsKey) as? [Questions]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: kMsgNameKey)
    aCoder.encode(internalIdentifier, forKey: kMsgInternalIdentifierKey)
    aCoder.encode(image, forKey: kMsgImageKey)
    aCoder.encode(basePrice, forKey: kMsgBasePriceKey)
    aCoder.encode(questions, forKey: kMsgQuestionsKey)
  }

}
