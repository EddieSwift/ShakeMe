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
    let questionApiURL = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"
    private let coreDataService: CoreDataServiceProvider
    private let networkingService: NetworkingServiceProvider
    private let internetReachability: InternetReachabilityProvider
    private var allSavedAnswers = [CustomAnswer]()
    var isLoadingDataStateHandler: ((Bool) -> Void)?
    private var isLoadingData = false {
        didSet {
            isLoadingDataStateHandler?(isLoadingData)
        }
    }
    init(_ coreDataService: CoreDataServiceProvider,
         _ networkService: NetworkingServiceProvider,
         _ internetReachability: InternetReachability) {
        self.coreDataService = coreDataService
        self.networkingService = networkService
        self.internetReachability = internetReachability
    }
    func numberOfAnswers() -> Int {
        return allSavedAnswers.count
    }
    func answer(at index: Int) -> CustomAnswer {
        return allSavedAnswers[index]
    }
    // MARK: - Network Methods
    func getShakedAnswer(completion: @escaping (Answer) -> Void) {
        isLoadingData = true
        networkingService.getAnswer(questionApiURL) { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .success(let fetchedAnswer):
                let answer = Answer(answer: fetchedAnswer)
                completion(answer)
            case .error(let error):
                let customAnswer = self.getCustomAnswer()
                completion(customAnswer)
                print(error.localizedDescription)
            }
            self.isLoadingData = false
        }
    }
    func fetchAnswers() {
        allSavedAnswers = coreDataService.fetchAllAnswers()
    }
    // MARK: - Data Methods
    private func getCustomAnswer() -> Answer {
        allSavedAnswers = coreDataService.fetchAllAnswers()
        let randomAnswer = allSavedAnswers.randomElement()
        return randomAnswer?.toAnswer() ?? Answer(answer: L10n.turnOnInternet)
    }
}
