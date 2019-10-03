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
        let mainViewController = StoryboardScene.Main.mainViewController.instantiate()
        let networkService = NetworkingService()
        let coreDataService = CoreDataService()
        let internetReachability = InternetReachability()
        let mainModel = MainModel(coreDataService: coreDataService,
                                  networkService: networkService,
                                  internetReachability: internetReachability)
        let mainViewModel = MainViewModel(mainModel)
        mainViewController.setMainViewModel(mainViewModel)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
        return true
    }
}
