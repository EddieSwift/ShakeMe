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

    var shakeAction: PublishSubject<Void> {
      return mainModel.shakeAction
    }

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
                return answer.toPresentableAnswer().text
        }
    }

    var shakeCounter: Observable<String> {
      return mainModel.shakeCounter.asObservable().map { count -> String in
        return L10n.shakes(count)
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

}
