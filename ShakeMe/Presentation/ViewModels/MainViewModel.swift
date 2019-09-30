//
//  MainViewModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

class MainViewModel {
    private let model: MainModel
    init(model: MainModel) {
        self.model = model
    }
    // ViewModel should pass observation closure from VC to Model.
    // Also, it "maps" UI terms (spinner animation) to Model terms (data loading)
    var shouldAnimateLoadingStateHandler: ((Bool) -> Void)? {
        didSet {
            model.isLoadingDataStateHandler = shouldAnimateLoadingStateHandler
        }
    }
}
