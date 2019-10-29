//
//  PresentableAnswer.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/30/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy, HH:mm"
    return formatter
}()

struct PresentableAnswer {

    var text: String
    var date: String

    init(text: String, date: Date) {
        self.date = dateFormatter.string(from: date)
        self.text = text
    }

}
