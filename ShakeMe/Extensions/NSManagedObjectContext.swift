//
//  NSManagedObjectContext.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 10/20/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    func returnPerformAndWait<T>(_ work: () -> T) -> T {
        var result: T!

        performAndWait {
            result = work()
        }

        return result
    }
}
