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
import RxRelay

class MainViewModel {

    // MARK: - Properties

    // RxSwift
    private let mainModel: MainModel
    let shakeAction = PublishSubject<Void>()

    var loadingState: Observable<Bool> {
        return mainModel.loading.asObservable()
    }

    private let disposeBag = DisposeBag()

    var text: Observable<String> {
        return mainModel.text.asObservable()
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

    private func setupBindings() {
        shakeAction.subscribe(onNext: { [weak self] in
            self?.requestData()
        })
    }

    private func requestData() {
//        mainModel.getShakedAnswer()
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
