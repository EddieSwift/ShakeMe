//
//  SettingsTableViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/10/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let rowHeight: CGFloat = 80.0

final class SettingsTableViewController: UITableViewController {

    // MARK: - Outlets

    private var settingsViewModel: SettingsViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Init Methods

    init(_ settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight

        setupUI()
        setupBindigns()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        settingsViewModel.fetchAnswers {
            tableView.reloadData()
        }
    }

    // MARK: - Bindings

    private func setupBindigns() {
        tableView.rx.itemDeleted
            .subscribe(onNext: {
                self.settingsViewModel.deleteAnswer(at: $0)
                self.tableView.deleteRows(at: [$0], with: .fade)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Setup UI Constraints

    private func setupUI() {
        title = L10n.settings
        tableView.allowsSelection = false
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: "AnswerTableViewCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped))
    }

    // MARK: - Bar Button Action Methods

    @objc private func addTapped() {
        let alert = UIAlertController(title: L10n.newAnswer,
                                      message: L10n.addCustomAnswer,
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: L10n.save, style: .default) { (_) in
            guard let textField = alert.textFields?.first,
                let newAnswer = textField.text else {
                    return
            }

            // Show alert if try save empty string answer
            if newAnswer.count < 1 {
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

    // MARK: - Alert metod

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.numberOfAnswers()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AnswerTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell",
                                                       for: indexPath) as? AnswerTableViewCell else {
                                                        fatalError("Cell error")
        }

        let answer = settingsViewModel.answerAtIndexPath(indexPath: indexPath)
        cell.configure(with: answer)
        return cell
    }

}
