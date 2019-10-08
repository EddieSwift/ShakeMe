//
//  MainViewModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {
    // MARK: - Properties
    private let mainModel: MainModel
    init(_ mainModel: MainModel) {
        self.mainModel = mainModel
    }
    var shouldAnimateLoadingStateHandler: ((Bool) -> Void)? {
        didSet {
            mainModel.isLoadingDataStateHandler = shouldAnimateLoadingStateHandler
        }
    }
    // MARK: - Network Methods
    func shakeDetected(completion: @escaping (PresentableAnswer) -> Void) {
        mainModel.getShakedAnswer { fetchedAnswer in
            var answer = fetchedAnswer.toPresentableAnswer()
            answer.answerText = answer.answerText.uppercased()
            completion(answer)
        }
    }
    // MARK: - Secure Storage Methods
    func updateInStorage() {
        mainModel.updateInStorage()
    }
    func loadFromStorage(completion: @escaping (Int) -> Void) {
        mainModel.loadFromStorage { counter in
            completion(counter)
        }
    }
}
