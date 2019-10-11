//
//  MainModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

final class MainModel {
    // MARK: - Properties
    private let coreDataService: CoreDataServiceProvider
    private let networkingService: NetworkingServiceProvider
    private let internetReachability: InternetReachabilityProvider
    private let secureStorageService: SecureStorageServiceProvider
    private var shakesCounter: Int!
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
    }
    // MARK: - Network Methods
    func getShakedAnswer(completion: @escaping (Answer) -> Void) {
        isLoadingData = true
        networkingService.getAnswer { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .success(let fetchedAnswer):
                let answer = Answer(answerText: fetchedAnswer)
                completion(answer)
                self.saveNewAnswer(newAnswer: fetchedAnswer)
            case .error(let error):
                let customAnswer = self.getCustomAnswer()
                completion(customAnswer)
                print(error.localizedDescription)
            }
            self.isLoadingData = false
        }
    }
    // MARK: - Data Methods
    private func getCustomAnswer() -> Answer {
        let randomAnswer = coreDataService.fetchAllAnswers().randomElement() ?? Answer(answerText: L10n.turnOnInternet)
        return randomAnswer
    }

    private func saveNewAnswer(newAnswer: String) {
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
