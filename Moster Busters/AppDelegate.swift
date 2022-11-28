//
//  AppDelegate.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 26.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - UIApplication

    var window: UIWindow?

    let lauchScreenStoryBoard = UIStoryboard(name: "LaunchScreen", bundle: .main)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        startApplicationProcess()
        return true
    }

    //MARK: - Methods
     func startApplicationProcess() {
         runLaunchScreen()
         runMainFlow()
     }
     func runMainFlow() {
         DispatchQueue.main.async {
             self.window?.rootViewController = StartGameViewController()
         }
     }

     func runLaunchScreen() {
         let lauchScreenViewController = lauchScreenStoryBoard
             .instantiateInitialViewController()
         window?.rootViewController = lauchScreenViewController
     }
}


