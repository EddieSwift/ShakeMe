//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import CoreData

// my real shake ;)

var answers: [NSManagedObject] = []

class MainViewController: UIViewController {
    
    let questionApiURL = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"
    let customAnswer = CustomAnswer()

    // MARK: - Outlets
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerLabel.text = "Why are you shakin me?"
        self.activityIndicator.hidesWhenStopped = true
        self.becomeFirstResponder() // To get shake gesture
    }
    
    // MARK: - Motions
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("motionBegan: Shake Began!")
        } 
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
            if InternetReachability.isConnectedToNetwork() {
                getAnswer(questionApiURL)
            } else {
                customAnswer.fetchAllAnswers()
                let element = answers.randomElement()
                self.answerLabel.textColor = self.randomColor()
                
                if let customAnswer = element?.value(forKey: "answer") as? String {
                    self.answerLabel.text = customAnswer
                }
            }
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    
    // Become the first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - Help Method
    
    func randomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: - Network Method
    
    private func getAnswer(_ apiUrl: String) {
        startAnimating()
        NetworkingService.shared.getAnswer(apiUrl) { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .success(let answer):
                self.answerLabel.text = answer
                
                // Change color after text updated
                DispatchQueue.main.async {
                    self.answerLabel.textColor = self.randomColor()
                }
                
            case .error(let error):
                print(error.localizedDescription)
            case .none: break
            }
            
            self.stopAnimating()
        }
    }
    
    // MARK: - Indicator Methods
    func startAnimating() {
        self.answerLabel.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.activityIndicator.color = self.answerLabel.textColor
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.answerLabel.isHidden = false
    }
}
