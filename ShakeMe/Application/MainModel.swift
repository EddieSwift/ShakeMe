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
    private var secureCounter: Int!
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
    // MARK: - Secure Storage Methods
    func saveToStorage(counter: Int) {
        secureStorageService.saveToStorage(counter: counter)
    }
    func updateInStorage() {
        secureStorageService.updateInStorage(counter: secureCounter + 1)
    }
    func loadFromStorage(completion: @escaping (Int) -> Void) {
        secureCounter = secureStorageService.loadFromStorage()
        if secureCounter == 0 {
            secureStorageService.saveToStorage(counter: secureCounter)
        }
        completion(secureCounter)
    }
}
