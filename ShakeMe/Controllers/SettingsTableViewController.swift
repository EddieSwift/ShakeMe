//
//  SettingsTableViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
    
    var answers: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllAnswers()
    }
    
    // MARK: - Actions
    
    @IBAction func addCustomAnswer(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New answer", message: "Add a new custom answer.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
            
            guard let textField = alert.textFields?.first,
                let answerToSave = textField.text else {
                    return
            }
            
            // Show alert if try save empty string answer
            if answerToSave.count < 1 {
                self.emptyStringAlert()
                return
            }
            
            self.save(answer: answerToSave)
            self.tableView.reloadData()
        }
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Core Data
    
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
    
    // MARK: - Help metods
    
    func emptyStringAlert() {
        let alert = UIAlertController(title: "Warning", message: "Answer should be at least one character or more. Try again, please.", preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let answer = answers[indexPath.row]
        
        cell.textLabel?.text = answer.value(forKey: "answer") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let answer = answers[indexPath.row]
            deleteAnswer(answer: answer)
            fetchAllAnswers()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
