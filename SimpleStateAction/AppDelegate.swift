//
//  AppDelegate.swift
//  SimpleStateAction
//
//  Created by Yuske Fukuyama on 2018/12/21.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = StateActionViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  

}

