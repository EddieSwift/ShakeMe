//
//  SettingsTableViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {
    private var settingsViewModel: SettingsViewModel!
    func setSettingsViewModel(_ settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = L10n.settings
        tableView.register(UINib.init(nibName: AnswerTableViewCell.nibName,
                                      bundle: Bundle.main),
                           forCellReuseIdentifier: AnswerTableViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.fetchAnswers {
            tableView.reloadData()
        }
    }
    // MARK: - Actions
    @IBAction private func addCustomAnswer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: L10n.newAnswer,
                                      message: L10n.addCustomAnswer,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: L10n.save, style: .default) { (_) in
            guard let textField = alert.textFields?.first,
                let newAnswer = textField.text else {
                    return
            }
            if newAnswer.count < 1 {   // Show alert if try save empty string answer
                self.emptyStringAlert()
                return
            }
            self.settingsViewModel.saveAnswer(newAnswer: newAnswer)
            self.settingsViewModel.fetchAnswers {
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
        let cancleAction = UIAlertAction(title: L10n.cancel, style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
    // MARK: - Help metods
    private func emptyStringAlert() {
        let alert = UIAlertController(title: L10n.warning,
                                      message: L10n.answerLength,
                                      preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: L10n.ok, style: .cancel)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
}
extension SettingsTableViewController {
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.numberOfAnswersInSection()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AnswerTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier,
                                                       for: indexPath) as? AnswerTableViewCell else {
                                                        fatalError("Cell error")
        }
        let answer = settingsViewModel.answerAtIndexPath(indexPath: indexPath)
        cell.configure(with: answer)
        return cell
    }
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}
