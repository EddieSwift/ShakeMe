//
//  SettingsViewModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SettingsViewModel {

    // MARK: - Properties

    private let settingsModel: SettingsModel

    private let disposeBag = DisposeBag()

    init(_ settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
    }

    // MARK: - Methods

    func fetchAnswers(completion: () -> Void) {
        settingsModel.fetchAnswers { _ in
            completion()
        }
    }

    func numberOfAnswers() -> Int {
        return settingsModel.numberOfAnswers()
    }

    func answerAtIndexPath(indexPath: IndexPath) -> PresentableAnswer {
        return settingsModel.answer(at: indexPath).toPresentableAnswer()
    }

    func saveAnswer(newAnswer: String) {
        settingsModel.saveNewAnswer(newAnswer: newAnswer)
    }

    func deleteAnswer(at indexPath: IndexPath) {
        return settingsModel.deleteAnswer(at: indexPath)
    }

}
