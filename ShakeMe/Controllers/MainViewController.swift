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

struct Answer {
    let answer: String
}

let questionApiURL = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"
var answer = String()

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
    }
    
    // MARK: - Motions
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            print("***")
            print("motionBegan: Shake Began!")
        }
        
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            getJSON(questionApiURL)
        }
        self.answerLabel.textColor = randomColor()
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

        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: - Network Methods
    func getJSON(_ apiUrl: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(apiUrl).responseJSON { response in
            
            if response.result.value != nil {
                let json = JSON(response.result.value!)
                let result = json["magic"]["answer"].stringValue
                
                print(json)
                print("result: \(result)")
                
                self.answerLabel.text = result
                
            } else {
                print(response.error?.localizedDescription as Any)
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false  
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
