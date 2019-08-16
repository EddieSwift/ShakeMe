//
//  AnswerTableViewCell.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/13/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    public static let identifier = "AnswerTableViewCell"
    private static let nibName = "AnswerTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func registerIn(tableView: UITableView) {
        let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func configureWith(answer: String?) {
        self.answerLabel?.text = answer
    }
}
