//
//  SettingsTableViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let coreDataService = CoreDataService.shared
    let customAnswer: CustomAnswer? = nil
    private var allSavedAnswers = [CustomAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        AnswerTableViewCell.registerIn(tableView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allSavedAnswers = coreDataService.fetchAllAnswers()
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
            
            self.coreDataService.save(answerToSave)
            self.allSavedAnswers = self.coreDataService.fetchAllAnswers()
            self.tableView.reloadData()
        }
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
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
        return allSavedAnswers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AnswerTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
        
        let answer = allSavedAnswers[indexPath.row]
        cell.configureWith(answer: answer.value(forKey: "answerText") as? String)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            coreDataService.deleteAnswer(answer: allSavedAnswers[indexPath.row])
            allSavedAnswers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}
