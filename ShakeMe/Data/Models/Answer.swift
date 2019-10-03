//
//  Answer.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 9/30/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Foundation

struct Answer {
    var answer: String
}
extension Answer {
    func toPresentableAnswer() -> PresentableAnswer {
        return PresentableAnswer(answerText: answer)
    }
}
