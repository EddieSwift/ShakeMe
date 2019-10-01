//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private var mainViewModel: MainViewModel!
    // MARK: - Outlets
    @IBOutlet private weak var questionTextField: UITextField!
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var shakeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerLabel.text = L10n.shakingMe
        self.answerLabel.textColor = Asset.Colors.green.color
        self.shakeImageView.image = Asset.Images.shakeImage.image
        self.activityIndicator.hidesWhenStopped = true
        self.becomeFirstResponder() // To get shake gesture
        mainViewModel.shouldAnimateLoadingStateHandler = { [weak self] shouldAnimate in
            self?.setAnimationEnabled(shouldAnimate)
        }
    }
    func setMainViewModel(_ mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }
    // MARK: - Motions
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("motionBegan")
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { // Enable detection of shake motion
            mainViewModel.shakeDetected { fetchedAnswer in
                let answer = fetchedAnswer.answerText
                self.answerLabel.text = answer
                self.answerLabel.textColor = self.randomColor()
            }
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    override var canBecomeFirstResponder: Bool { // Become the first responder to get shake motion
        return true
    }
    // MARK: - Indicator Methods
    private func setAnimationEnabled(_ enabled: Bool) {
        if enabled {
            self.answerLabel.isHidden = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.activityIndicator.color = self.answerLabel.textColor
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.answerLabel.isHidden = false
        }
    }
    // MARK: - Help Methods
    private func randomColor() -> UIColor {
        //Generate between 0 to 1
        let red   = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue  = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
