//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var questionTextField: UITextField!
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var shakeImageView: UIImageView!
    private var mainViewModel: MainViewModel!
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.settings,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingsTapped))
    }
    // MARK: - Setter Method
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
                //                let answer = fetchedAnswer.answerText
                self.answerLabel.text = fetchedAnswer.answerText
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
    // MARK: - Navigation Methods
    @objc func settingsTapped() {
        presentSettings()
    }
    private func presentSettings() {
        let settingsViewController = StoryboardScene.Main.settingsTableViewController.instantiate()
        let coreDataService = CoreDataService()
        let settingsModel = SettingsModel(coreDataService)
        let settingsViewModel = SettingsViewModel(settingsModel)
        settingsViewController.setSettingsViewModel(settingsViewModel)
        self.navigationController?.pushViewController(settingsViewController, animated: true)
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
