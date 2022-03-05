//
//  Questions.swift
//
//  Created by Sameer Khan on 17/07/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Questions: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kQuestionsAppViewTypeKey: String = "appViewType"
  private let kQuestionsSpecificationNameKey: String = "specificationName"
  private let kQuestionsSpecificationIdKey: String = "specificationId"
  private let kQuestionsSpecificationValueKey: String = "specificationValue"
  private let kQuestionsViewTypeKey: String = "viewType"
  private let kQuestionsConditionIdKey: String = "conditionId"
  private let kQuestionsConditionSubHeadKey: String = "conditionSubHead"
  private let kQuestionsConditionValueKey: String = "conditionValue"
  private let kQuestionsPriorityOrderKey: String = "priorityOrder"
  private let kQuestionsTypeKey: String = "type"
  private let kQuestionsIsInputKey: String = "isInput"
  private let kQuestionsConditionNameKey: String = "conditionName"

  // MARK: Properties
  public var appViewType: String?
  public var specificationName: String?
  public var specificationId: String?
  public var specificationValue: [SpecificationValue]?
  public var viewType: String?
  public var conditionId: String?
  public var conditionSubHead: String?
  public var conditionValue: [ConditionValue]?
  public var priorityOrder: String?
  public var type: String?
  public var isInput: String?
  public var conditionName: String?

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
    appViewType = json[kQuestionsAppViewTypeKey].string
    specificationName = json[kQuestionsSpecificationNameKey].string
    specificationId = json[kQuestionsSpecificationIdKey].string
    if let items = json[kQuestionsSpecificationValueKey].array { specificationValue = items.map { SpecificationValue(json: $0) } }
    viewType = json[kQuestionsViewTypeKey].string
    conditionId = json[kQuestionsConditionIdKey].string
    conditionSubHead = json[kQuestionsConditionSubHeadKey].string
    if let items = json[kQuestionsConditionValueKey].array { conditionValue = items.map { ConditionValue(json: $0) } }
    priorityOrder = json[kQuestionsPriorityOrderKey].string
    type = json[kQuestionsTypeKey].string
    isInput = json[kQuestionsIsInputKey].string
    conditionName = json[kQuestionsConditionNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = appViewType { dictionary[kQuestionsAppViewTypeKey] = value }
    if let value = specificationName { dictionary[kQuestionsSpecificationNameKey] = value }
    if let value = specificationId { dictionary[kQuestionsSpecificationIdKey] = value }
    if let value = specificationValue { dictionary[kQuestionsSpecificationValueKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = viewType { dictionary[kQuestionsViewTypeKey] = value }
    if let value = conditionId { dictionary[kQuestionsConditionIdKey] = value }
    if let value = conditionSubHead { dictionary[kQuestionsConditionSubHeadKey] = value }
    if let value = conditionValue { dictionary[kQuestionsConditionValueKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = priorityOrder { dictionary[kQuestionsPriorityOrderKey] = value }
    if let value = type { dictionary[kQuestionsTypeKey] = value }
    if let value = isInput { dictionary[kQuestionsIsInputKey] = value }
    if let value = conditionName { dictionary[kQuestionsConditionNameKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.appViewType = aDecoder.decodeObject(forKey: kQuestionsAppViewTypeKey) as? String
    self.specificationName = aDecoder.decodeObject(forKey: kQuestionsSpecificationNameKey) as? String
    self.specificationId = aDecoder.decodeObject(forKey: kQuestionsSpecificationIdKey) as? String
    self.specificationValue = aDecoder.decodeObject(forKey: kQuestionsSpecificationValueKey) as? [SpecificationValue]
    self.viewType = aDecoder.decodeObject(forKey: kQuestionsViewTypeKey) as? String
    self.conditionId = aDecoder.decodeObject(forKey: kQuestionsConditionIdKey) as? String
    self.conditionSubHead = aDecoder.decodeObject(forKey: kQuestionsConditionSubHeadKey) as? String
    self.conditionValue = aDecoder.decodeObject(forKey: kQuestionsConditionValueKey) as? [ConditionValue]
    self.priorityOrder = aDecoder.decodeObject(forKey: kQuestionsPriorityOrderKey) as? String
    self.type = aDecoder.decodeObject(forKey: kQuestionsTypeKey) as? String
    self.isInput = aDecoder.decodeObject(forKey: kQuestionsIsInputKey) as? String
    self.conditionName = aDecoder.decodeObject(forKey: kQuestionsConditionNameKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(appViewType, forKey: kQuestionsAppViewTypeKey)
    aCoder.encode(specificationName, forKey: kQuestionsSpecificationNameKey)
    aCoder.encode(specificationId, forKey: kQuestionsSpecificationIdKey)
    aCoder.encode(specificationValue, forKey: kQuestionsSpecificationValueKey)
    aCoder.encode(viewType, forKey: kQuestionsViewTypeKey)
    aCoder.encode(conditionId, forKey: kQuestionsConditionIdKey)
    aCoder.encode(conditionSubHead, forKey: kQuestionsConditionSubHeadKey)
    aCoder.encode(conditionValue, forKey: kQuestionsConditionValueKey)
    aCoder.encode(priorityOrder, forKey: kQuestionsPriorityOrderKey)
    aCoder.encode(type, forKey: kQuestionsTypeKey)
    aCoder.encode(isInput, forKey: kQuestionsIsInputKey)
    aCoder.encode(conditionName, forKey: kQuestionsConditionNameKey)
  }

}
