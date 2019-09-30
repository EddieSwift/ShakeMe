//
//  MainModel.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/29/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

class MainModel {
    // upper layer (view model) may observe `isLoadingData` changes using closure
    var isLoadingDataStateHandler: ((Bool) -> Void)?
    // model stores "state", it knows if data is loading right now
    private var isLoadingData = false {
        didSet {
            isLoadingDataStateHandler?(isLoadingData)
        }
    }
    private func loadData() {
        isLoadingData = true
        /*
        .... data loading logic
        */
        isLoadingData = false
    }
}
