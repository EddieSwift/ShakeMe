//
//  CustomAnswer+CoreDataProperties.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

import CoreData

extension CustomAnswer {
    @NSManaged public var answerText: String?
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomAnswer> {
        return NSFetchRequest<CustomAnswer>(entityName: "CustomAnswer")
    }
    func toAnswer() -> Answer {
        return Answer(answer: answerText ?? "")
    }
}
