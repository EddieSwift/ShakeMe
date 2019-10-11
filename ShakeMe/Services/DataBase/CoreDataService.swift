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

    func fetchAllAnswers() -> [Answer] {
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "CustomAnswer")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "answerDate", ascending: false)]
        do {
            guard let answers = try backgroundContext
                .fetch(fetchRequest) as? [CustomAnswer] else { return [Answer]() }
            return answers.map { $0.toAnswer() }
        } catch let error as NSError {
            print("Could not fetch. \(error.localizedDescription), \(error.userInfo)")
        }
        return [Answer]()
    }

    public func save(_ text: String) {
        guard let context = backgroundContext else { return }
        guard let answer = NSEntityDescription.insertNewObject(forEntityName: "CustomAnswer",
                                                               into: context) as? CustomAnswer else { return }
        answer.answerText = text
        answer.answerDate = Date()
        answer.answerId = UUID().uuidString

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func delete(_ answer: Answer) {
        guard let context = backgroundContext else { return }

        var fetchResults: [CustomAnswer] = []

        backgroundContext.performAndWait {
            let fetchRequest: NSFetchRequest<CustomAnswer> = CustomAnswer.fetchRequest()
            do {
                fetchResults = try backgroundContext.fetch(fetchRequest)
            } catch {
                print("Fetch error")
            }
        }

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
