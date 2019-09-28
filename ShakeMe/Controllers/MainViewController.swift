//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    let questionApiURL = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"
    let customAnswer: CustomAnswer? = nil
    private var allSavedAnswers = [CustomAnswer]()
    private var networkingService: NetworkingServiceProvider!
    private var coreDataService: CoreDataServiceProvider!
    func setNetworkService(_ networkService: NetworkingServiceProvider) {
        self.networkingService = networkService
    }
    func setCoreDataService(_ coreDataService: CoreDataServiceProvider) {
        self.coreDataService = coreDataService
    }
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
    }
    // MARK: - Motions
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("motionBegan")
        }
    }
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if InternetReachability.isConnectedToNetwork() {
                getAnswer(questionApiURL)
            } else {
                allSavedAnswers = coreDataService.fetchAllAnswers()
                if allSavedAnswers.isEmpty {
                    showAlertNoCustomAnswersAndInternet()
                    return
                }
                showCustomAnswer()
            }
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    // Become the first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        return true
    }
    // MARK: - Help Methods
    private func showCustomAnswer() {
        allSavedAnswers = coreDataService.fetchAllAnswers()
        let element = allSavedAnswers.randomElement()
        self.answerLabel.textColor = self.randomColor()
        if let customAnswer = element?.answerText {
            self.answerLabel.text = customAnswer
        }
    }
    private func randomColor() -> UIColor {
        //Generate between 0 to 1
        let red   = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue  = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    private func showAlertNoCustomAnswersAndInternet() {
        let alert = UIAlertController(title: L10n.warning,
                                      message: L10n.turnOnInternet,
                                      preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: L10n.ok, style: .cancel)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
    // MARK: - Network Method
    private func getAnswer(_ apiUrl: String) {
        startAnimating()
        networkingService.getAnswer(apiUrl) { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .success(let answer):
                self.answerLabel.text = answer
                // Change color after text updated
                DispatchQueue.main.async {
                    self.answerLabel.textColor = self.randomColor()
                }
            case .error(let error):
                self.showCustomAnswer()
                print(error.localizedDescription)
            }
            self.stopAnimating()
        }
    }
    // MARK: - Indicator Methods
    private func startAnimating() {
        self.answerLabel.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.activityIndicator.color = self.answerLabel.textColor
        self.activityIndicator.startAnimating()
    }
    private func stopAnimating() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.answerLabel.isHidden = false
    }
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsTableViewControllerIdentifier" {
            if let settingsViewController = segue.destination as? SettingsTableViewController {
                settingsViewController.setCoreDataService(coreDataService)
            }
        }
    }
}
