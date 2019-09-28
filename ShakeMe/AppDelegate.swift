//
//  AppDelegate.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/9/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            as? UINavigationController
        let mainViewController = navigationController?.topViewController as? MainViewController
        let networkService = NetworkingService()
        let coreDataService = CoreDataService()
        mainViewController?.setNetworkService(networkService)
        mainViewController?.setCoreDataService(coreDataService)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
