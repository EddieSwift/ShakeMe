//
//  CustomAnswer+CoreDataClass.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

@objc(CustomAnswer)
public class CustomAnswer: NSManagedObject {
    
    func fetchAllAnswers() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "CustomAnswer")
        
        do {
            answers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(answer: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CustomAnswer", in: managedContext)!
        
        let customAnswer = NSManagedObject(entity: entity, insertInto: managedContext)
        
        customAnswer.setValue(answer, forKey: "answer")
        
        do {
            try managedContext.save()
            answers.append(customAnswer)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAnswer(answer: NSManagedObject) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.delete(answer)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }

}
