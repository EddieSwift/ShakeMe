//
//  MainModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MainModel {

    // MARK: - Properties

    private let coreDataService: CoreDataServiceProvider
    private let networkingService: NetworkingServiceProvider
    private let internetReachability: InternetReachabilityProvider
    private let secureStorageService: SecureStorageServiceProvider

    var shakeCounter = BehaviorRelay<Int>(value: 0)
    let shakeAction = PublishSubject<Void>()
    let answer = BehaviorRelay<Answer?>(value: nil)
    let loading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()

    init(coreDataService: CoreDataServiceProvider,
         networkService: NetworkingServiceProvider,
         internetReachability: InternetReachability,
         secureStorageService: SecureStorageService) {
        self.coreDataService = coreDataService
        self.networkingService = networkService
        self.internetReachability = internetReachability
        self.secureStorageService = secureStorageService

        setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {
        shakeCounter.accept(secureStorageService.loadFromStorage())
        shakeAction.subscribe(onNext: { [weak self] in
            self?.loadShakesCounter()
        }).disposed(by: disposeBag)
    }

    // MARK: - Network Methods

    func getShakedAnswer() {
        self.loading.onNext(true)
        networkingService.getAnswer { [weak self] state in
            self?.loading.onNext(false)
            guard let `self` = self else { return }
            switch state {
            case .success(let fetchedAnswer):
                self.saveNewAnswer(fetchedAnswer)
                self.answer.accept(Answer(text: fetchedAnswer))
            case .error(let error):
                let customAnswer = self.getCustomAnswer()
                self.answer.accept(customAnswer)
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Data Methods

    private func getCustomAnswer() -> Answer {
        let randomAnswer = coreDataService.fetchAllAnswers().randomElement() ?? Answer(text: L10n.turnOnInternet)
        return randomAnswer
    }

    private func saveNewAnswer(_ newAnswer: String) {
        coreDataService.save(newAnswer)
    }

    // MARK: - Shakes Counter Methods

    func loadShakesCounter() {
        secureStorageService.updateInStorage(counter: secureStorageService.loadFromStorage() + 1)
        shakeCounter.accept(secureStorageService.loadFromStorage())
    }

}
