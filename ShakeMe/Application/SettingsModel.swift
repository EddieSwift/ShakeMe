//
//  SettingsModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation
import RxSwift

class SettingsModel {

    // MARK: - Properties

    private let coreDataService: CoreDataServiceProvider
    private var allSavedAnswers = [Answer]()

    init(_ coreDataService: CoreDataServiceProvider) {
        self.coreDataService = coreDataService
    }

    // MARK: - Methods

    func fetchAnswers(completion: ([Answer]) -> Void) {
        allSavedAnswers = coreDataService.fetchAllAnswers()
        completion(allSavedAnswers)
    }

    func saveNewAnswer(newAnswer: String) {
        coreDataService.save(newAnswer)
    }

    func numberOfAnswers() -> Int {
        return allSavedAnswers.count
    }

    func answer(at indexPath: IndexPath) -> Answer {
        return allSavedAnswers[indexPath.row]
    }

    func deleteAnswer(at indexPath: IndexPath) {
        coreDataService.delete(allSavedAnswers[indexPath.row])
        allSavedAnswers.remove(at: indexPath.row)
    }

}
