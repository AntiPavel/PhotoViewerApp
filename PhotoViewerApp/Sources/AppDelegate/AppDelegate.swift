//
//  AppDelegate.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/14/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let photoViewController = PhotoListViewController(viewModel:
                                    PhotoListViewModel(store:
                                        PhotosStore(networkService: NetworkService())))
        let navigationController = UINavigationController(rootViewController: photoViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}
