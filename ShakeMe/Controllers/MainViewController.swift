//
//  MainViewController.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

let questionApiURL = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"
var answer = String()
//var reachability = InternetReachability()

class MainViewController: UIViewController {

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
                
                print("Internet connection OK")
                startAnimating()
                getAnswer(questionApiURL)
                
            } else {
                self.answerLabel.text = "Sorry... No Internet!"
                print("Internet connection FAILED")
            }

        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - Help Methods
    func randomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: - Network Methods
    func getAnswer(_ apiUrl: String) {
        Alamofire.request(apiUrl).responseJSON { response in
            if response.result.value != nil {
                
                let json = JSON(response.result.value!)
                let answer = json["magic"]["answer"].stringValue
                
                self.answerLabel.text = answer
                
                // Change color after text updated
                DispatchQueue.main.async {
                    self.answerLabel.textColor = self.randomColor()
                }
                
            } else {
                print(response.error?.localizedDescription as Any)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
