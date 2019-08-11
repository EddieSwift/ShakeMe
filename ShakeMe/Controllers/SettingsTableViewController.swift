//
//  SettingsTableViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var answers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Actions
    
    @IBAction func addCustomAnswer(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New answer", message: "Add a new custom answer", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in

            guard let textField = alert.textFields?.first,
                let answerToSave = textField.text else {
                    return
            }
            
            if answerToSave.count < 1 { self.guardAlert() }
            
            self.answers.append(answerToSave)
            self.tableView.reloadData()
        }

        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()

        alert.addAction(saveAction)
        alert.addAction(cancleAction)

        present(alert, animated: true)
    }
    
    // MARK: - Help metods
    
    func guardAlert() {
        let alert = UIAlertController(title: "Error", message: "Answer should be at least one character or more. Try again, please.", preferredStyle: .alert)

        let cancleAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.row]

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
