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

    // RxSwift
    let text = BehaviorRelay<String?>(value: nil)
    let loading = PublishSubject<Bool>()

    var isLoadingDataStateHandler: ((Bool) -> Void)?
    private var isLoadingData = false {
        didSet {
            isLoadingDataStateHandler?(isLoadingData)
        }
    }

    init(coreDataService: CoreDataServiceProvider,
         networkService: NetworkingServiceProvider,
         internetReachability: InternetReachability,
         secureStorageService: SecureStorageService) {
        self.coreDataService = coreDataService
        self.networkingService = networkService
        self.internetReachability = internetReachability
        self.secureStorageService = secureStorageService

        // RxSwift
    }

    // MARK: - Network Methods

    func getShakedAnswer(completion: @escaping (Answer) -> Void) {
        isLoadingData = true
        // RxSwift
        self.loading.onNext(true)
        networkingService.getAnswer { [weak self] state in
            // RxSwift
            self?.loading.onNext(false)

            guard let `self` = self else { return }
            switch state {
            case .success(let fetchedAnswer):
                self.saveNewAnswer(fetchedAnswer)
                let answer = Answer(text: fetchedAnswer)
//                completion(answer)
//                self.text.onNext(answer.text)
                self.text.accept(answer.text)
            case .error(let error):
                let customAnswer = self.getCustomAnswer()
//                self.text.on
//                completion(customAnswer)
//                self.text.onNext(customAnswer.text)
                self.text.accept(customAnswer.text)
                print(error.localizedDescription)
            }
            self.isLoadingData = false
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
