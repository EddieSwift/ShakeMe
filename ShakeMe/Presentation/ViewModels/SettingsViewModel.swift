//
//  SettingsViewModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel {
    // MARK: - Properties
    private let settingsModel: SettingsModel
    private var allSavedAnswers: [Answer]?
    init(_ settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
    }
    // MARK: - Methods
    func fetchAnswers(completion: () -> Void) {
        settingsModel.fetchAnswers { fetchedAnswers in
            self.allSavedAnswers = fetchedAnswers
            completion()
        }
    }
    func numberOfAnswersInSection() -> Int {
        return allSavedAnswers?.count ?? 0
    }
    func answerAtIndexPath(indexPath: IndexPath) -> PresentableAnswer {
        return allSavedAnswers?[indexPath.row]
            .toPresentableAnswer() ?? PresentableAnswer(answerText: L10n.turnOnInternet)
    }
    func saveAnswer(newAnswer: String) {
        settingsModel.saveNewAnswer(newAnswer: newAnswer)
    }
}
