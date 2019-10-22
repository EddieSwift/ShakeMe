//
//  AnswerTableViewCell.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AnswerTableViewCell: UITableViewCell {

    // MARK: - Outlets

    private var answerLabel: UILabel!
    private var dateLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    // MARK: - Init Methods

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with answer: PresentableAnswer) {
        self.answerLabel?.text = answer.text
        self.dateLabel.text = answer.date
    }

    // MARK: - Setup UI Methods

    private func setupUI() {
        setupAnswerUI()
        setupDateUI()
    }

    private func setupAnswerUI() {
        answerLabel = UILabel()
        answerLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(30)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(20)
        }
    }

    private func setupDateUI() {
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.right.equalTo(contentView).offset(-20)
        }
    }

}
