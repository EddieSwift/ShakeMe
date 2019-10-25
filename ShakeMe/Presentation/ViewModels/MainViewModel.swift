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
    let shakeAction = PublishSubject<Void>()

    var loadingState: Observable<Bool> {
        return mainModel.loading.asObservable()
    }

    private let disposeBag = DisposeBag()

    var answer: Observable<String> {
        return mainModel.answer.asObservable()
            .filter { $0 != nil }
            .map { answer -> String in
                guard let answer = answer else {
                    return "Custom Shake Answer"
                }
                return answer.uppercased() // PresentableAnswer(answer: answer).answer
        }
    }

    init(_ mainModel: MainModel) {
        self.mainModel = mainModel

        setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {
        shakeAction.subscribe(onNext: { [weak self] in
            self?.requestData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Network Methods

    private func requestData() {
        mainModel.getShakedAnswer()
    }

    // MARK: - Shakes Counter Methods

    func incrementShakesCounter() {
        mainModel.incrementShakesCounter()
    }

    func loadShakesCounter() -> Int {
        return mainModel.loadShakesCounter()
    }
}
