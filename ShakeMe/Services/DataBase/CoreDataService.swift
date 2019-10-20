//
//  CoreDataService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/15/19.
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

protocol CoreDataServiceProvider {
    func fetchAllAnswers() -> [Answer]
    func save(_ text: String)
    func delete(_ answer: Answer)
    func createContainer(completion: @escaping (NSPersistentContainer) -> Void)
}

final public class CoreDataService: CoreDataServiceProvider {

    private var backgroundContext: NSManagedObjectContext!

    init() {
        createContainer { container in
            self.backgroundContext = container.newBackgroundContext()
            self.backgroundContext.automaticallyMergesChangesFromParent = true
        }
    }

    func fetchAllAnswers() -> [Answer] {
        var fetchResults: [CustomAnswer] = []
        guard let context = backgroundContext else { return [Answer]() }

        context.performAndWait {
            let fetchRequest: NSFetchRequest<CustomAnswer> = CustomAnswer.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(CustomAnswer.date), ascending: false)]

            do {
                fetchResults = try backgroundContext.fetch(fetchRequest)
            } catch {
                fatalError("Fetch error")
            }
        }

        return context.returnPerformAndWait {
            fetchResults.map { $0.toAnswer() }
        }
    }

    public func save(_ text: String) {
        guard let context = backgroundContext else { return }

        backgroundContext.performAndWait {
            let answer = CustomAnswer(text: text, insertIntoManagedObjectContext: context)
            answer.awakeFromInsert()

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }

    func delete(_ answer: Answer) {
        guard let context = backgroundContext else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CustomAnswer.self))

        if let identifier = answer.identifier {
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            backgroundContext.performAndWait {
                do {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch let error as NSError {
                    print("Error While Deleting Note: \(error.userInfo)")
                }
            }
        }
    }

    func createContainer(completion: @escaping
        (NSPersistentContainer) -> Void) { let container = NSPersistentContainer(name:
        "DataModel")

        container.loadPersistentStores(completionHandler: { _, error in
            guard error == nil else {
                fatalError("Failed to load store")
            }

            DispatchQueue.main.async { completion(container) }
        })
    }
}
