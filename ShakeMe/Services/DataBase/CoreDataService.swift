//
//  CoreDataService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/15/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import CoreData

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
        }
    }

    func fetch() -> [CustomAnswer] {
        var fetchResults: [CustomAnswer] = []
        guard let context = backgroundContext else { return fetchResults }
        context.performAndWait {
            let fetchRequest: NSFetchRequest<CustomAnswer> = CustomAnswer.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "answerDate", ascending: false)]
            do {
                fetchResults = try backgroundContext.fetch(fetchRequest)
            } catch {
                print("Fetch error")
            }
        }
        return fetchResults
    }

    func fetchAllAnswers() -> [Answer] {
        return  fetch().map { $0.toAnswer() }
    }

    public func save(_ text: String) {
        guard let context = backgroundContext else { return }
        context.automaticallyMergesChangesFromParent = true
        guard let answer = NSEntityDescription.insertNewObject(forEntityName: "CustomAnswer",
                                                               into: context) as? CustomAnswer else { return }
        answer.answerText = text
        answer.answerDate = Date()
        answer.answerId = UUID().uuidString
        context.performAndWait {
            do {
                try
                    context.save()
            } catch {
                print(error)
            }
        }
    }

    func delete(_ answer: Answer) {
        guard let context = backgroundContext else { return }

        let fetchResults = fetch()

        for obj in fetchResults where obj.answerId == answer.answerId {
            context.delete(obj)
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
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
