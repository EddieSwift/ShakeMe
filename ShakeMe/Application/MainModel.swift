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
    private var shakesCounter: Int!

    let answer = BehaviorRelay<String?>(value: nil)
    let loading = PublishSubject<Bool>()

    init(coreDataService: CoreDataServiceProvider,
         networkService: NetworkingServiceProvider,
         internetReachability: InternetReachability,
         secureStorageService: SecureStorageService) {
        self.coreDataService = coreDataService
        self.networkingService = networkService
        self.internetReachability = internetReachability
        self.secureStorageService = secureStorageService
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
                let answer = Answer(text: fetchedAnswer)
                self.answer.accept(answer.text)
            case .error(let error):
                let customAnswer = self.getCustomAnswer()
                self.answer.accept(customAnswer.text)
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

    func incrementShakesCounter() {
        secureStorageService.updateInStorage(counter: shakesCounter + 1)
    }

    func loadShakesCounter() -> Int {
        shakesCounter = secureStorageService.loadFromStorage()
        if shakesCounter == 0 {
            secureStorageService.saveToStorage(counter: shakesCounter)
        }
        return shakesCounter
    }

}
