//
//  AnswerTableViewCell.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import SnapKit

class AnswerTableViewCell: UITableViewCell {
    // MARK: - Outlets
    private var answerLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    // MARK: - Init Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with answer: PresentableAnswer) {
        self.answerLabel?.text = answer.answerText
    }
    // MARK: - Setup UI Constraints
    private func setupUI() {
        answerLabel = UILabel(frame: CGRect(x: 20, y: 18, width: 288, height: 20))
        answerLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(18)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(20)
        }
    }
}
