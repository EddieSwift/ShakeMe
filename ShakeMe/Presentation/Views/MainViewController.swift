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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.becomeFirstResponder() // To get shake gesture
        mainViewModel.shouldAnimateLoadingStateHandler = { [weak self] shouldAnimate in
            self?.setAnimationEnabled(shouldAnimate)
        }
    }
    // MARK: - Setup UI Constraints
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.settings,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingsTapped))
        view.backgroundColor = Asset.Colors.white.color
        title = L10n.shakeMe
        answerLabel = UILabel(frame: CGRect(x: 38, y: 498, width: 338, height: 36))
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.center = CGPoint(x: 160, y: 285)
        answerLabel.textAlignment = .center
        answerLabel.numberOfLines = 4
        answerLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        answerLabel.textColor = Asset.Colors.green.color
        answerLabel.text = L10n.shakingMe
        shakeImageView  = UIImageView(image: Asset.Images.shakeImage.image)
        shakeImageView.frame = CGRect(x: 147, y: 312, width: 120, height: 120)
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicator.hidesWhenStopped = true
        view.addSubview(answerLabel)
        view.addSubview(shakeImageView)
        view.addSubview(activityIndicator)
        shakeImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(view).offset(162)
        }
        shakeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-42)
        }
        activityIndicator.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(view).offset(162)
        }
    }
    // MARK: - Setter and Init Methods
    func setMainViewModel(_ mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
