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
        guard let rootViewController = window?.rootViewController as? UINavigationController,
            !rootViewController.viewControllers.isEmpty else {
                return false
        }
        if let mainViewController = rootViewController.viewControllers.first as? MainViewController {
            let networkService = NetworkingService()
            let coreDataService = CoreDataService()
            mainViewController.setNetworkService(networkService)
            mainViewController.setCoreDataService(coreDataService)
        }
        return true
    }
}
