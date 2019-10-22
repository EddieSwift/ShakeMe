//
//  MainViewModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import RxSwift
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
            answer.text = answer.text.uppercased()
            completion(answer)
        }
    }

    // MARK: - Shakes Counter Methods

    func incrementShakesCounter() {
        mainModel.incrementShakesCounter()
    }

    func loadShakesCounter() -> Int {
        return mainModel.loadShakesCounter()
    }

}
