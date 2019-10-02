//
//  SettingsModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

class SettingsModel {
    // MARK: - Properties
    private let coreDataService: CoreDataServiceProvider
    private var allSavedAnswers = [Answer]()
    init(_ coreDataService: CoreDataServiceProvider) {
        self.coreDataService = coreDataService
    }
    // MARK: - Methods
    func fetchAnswers(completion: ([Answer]) -> Void) {
        allSavedAnswers = coreDataService.fetchAllAnswers().map { $0.toAnswer() }
        completion(allSavedAnswers)
    }
    func saveNewAnswer(newAnswer: String) {
        coreDataService.save(newAnswer)
    }
}
