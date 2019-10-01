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
    // MARK: - Methods
    func shakeDetected(completion: @escaping (PresentableAnswer) -> Void) {
        mainModel.getShakedAnswer { fetchedAnswer in
            var answer = fetchedAnswer.toPresentableAnswer()
            answer.answerText = answer.answerText.uppercased()
            completion(answer) // uppercased()
        }
    }
}
