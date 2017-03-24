//
//  AppDelegate.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/17/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deviceToken: String = ""
    var user = User()
    var firstLaunch = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotification(application: application)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if !firstLaunch {
            showLockScreen()
        }else{
            firstLaunch = false
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotification(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Register notifications settings")
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken.base64EncodedString()
//        let deviceString = deviceToken.hexEncodedString()
        print("Device string: \(self.deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register push notifications")
        print("Error: \(error.localizedDescription)")
    }

}

extension AppDelegate {
    
    func showLockScreen(){
        if let vc = self.getVisibleViewController() {
            if !(vc is LockViewController) && !(vc is SignInViewController) {
                let lockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lockViewController") as! UINavigationController
                vc.present(lockVC, animated: true, completion: nil)
            }
        }
    }
    
    func getVisibleViewController()->UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            print("1) Top controller: \(NSStringFromClass(topController.classForCoder).components(separatedBy: ".").last!)")
            if topController is UINavigationController {
                topController = (topController as! UINavigationController).visibleViewController!
                print("2) Top controller: \(NSStringFromClass(topController.classForCoder).components(separatedBy: ".").last!)")
                return topController
            }else{
                return topController
            }
        }else{
            return nil
        }
    }
}

