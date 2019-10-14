//
//  CustomAnswer+CoreDataClass.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 10/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

import CoreData

extension CustomAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomAnswer> {
        return NSFetchRequest<CustomAnswer>(entityName: "CustomAnswer")
    }

    @NSManaged public var answerDate: Date?
    @NSManaged public var answerId: String?
    @NSManaged public var answerText: String?

    func toAnswer() -> Answer {
        return Answer(answerText: answerText ?? "", answerDate: answerDate, answerId: answerId)
    }
}
