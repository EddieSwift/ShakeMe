//
//  AnswerTableViewCell.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    public static let identifier = L10n.identifier
    public static let nibName = L10n.nibName
    // MARK: - Outlets
    @IBOutlet weak private var answerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(with answer: CustomAnswer) {
        self.answerLabel?.text = answer.answerText
    }
}
