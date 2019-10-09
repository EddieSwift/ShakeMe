//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - Outlets
    private var answerLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var shakeImageView: UIImageView!
    private var mainViewModel: MainViewModel!
    private var shakesCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainUI()
        self.becomeFirstResponder() // To get shake gesture
        mainViewModel.shouldAnimateLoadingStateHandler = { [weak self] shouldAnimate in
            self?.setAnimationEnabled(shouldAnimate)
        }
        shakesCounterLabel.text = "\(L10n.shakes): \(String(describing: mainViewModel.loadShakesCounter()))"
    }
    // MARK: - Setter and Init Methods
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - Setup UI Methods
    func setupMainUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.settings,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingsTapped))
        view.backgroundColor = Asset.Colors.white.color
        title = L10n.shakeMe
        setupAnswerUI()
        setupImageUI()
        setupCounterUI()
        setupIndicatorUI()
    }

    func setupAnswerUI() {
        answerLabel = UILabel()
        answerLabel.textAlignment = .center
        answerLabel.numberOfLines = 4
        answerLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        answerLabel.textColor = Asset.Colors.green.color
        answerLabel.text = L10n.shakingMe
        view.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(view).offset(162)
        }
    }

    func setupImageUI() {
        shakeImageView  = UIImageView(image: Asset.Images.shakeImage.image)
        view.addSubview(shakeImageView)
        shakeImageView.translatesAutoresizingMaskIntoConstraints = false
        shakeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-42)
        }
    }

    func setupCounterUI() {
        shakesCounterLabel = UILabel()
        shakesCounterLabel.textColor = Asset.Colors.green.color
        shakesCounterLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        view.addSubview(shakesCounterLabel)
        shakesCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        shakesCounterLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }

    func setupIndicatorUI() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(view).offset(162)
        }
    }
    // MARK: - Motions
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("motionBegan")
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { // Enable detection of shake motion
            let randomColor = self.randomColor()

            mainViewModel.shakeDetected { fetchedAnswer in
                self.answerLabel.text = fetchedAnswer.answerText
                self.answerLabel.textColor = randomColor
            }

            mainViewModel.incrementShakesCounter()
            shakesCounterLabel.text = "\(L10n.shakes): \(String(describing: mainViewModel.loadShakesCounter()))"
            shakesCounterLabel.textColor = randomColor
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
        let settingsViewController = SettingsTableViewController()
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
