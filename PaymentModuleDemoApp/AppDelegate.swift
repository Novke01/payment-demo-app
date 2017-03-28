//
//  AppDelegate.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/17/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceToken: String = ""
    let gcmMessageIDKey = "gcm.message_id"
    var user = User()
    var firstLaunch = true
    var firebasePushToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotification(application: application)
        
        FIRApp.configure()
        if let token = UserDefaults.standard.value(forKey: "firebaseToken") as? String {
            self.firebasePushToken = token
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.tokenRefreshNotification),
            name: .firInstanceIDTokenRefresh,
            object: nil)
        
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
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Register notifications settings")
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        self.deviceToken = deviceToken.base64EncodedString()
        //        let deviceString = deviceToken.hexEncodedString()
        print("Device string: \(self.deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register push notifications")
        print("Error: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func registerForPushNotification(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("• FIREBASE Instance token: \(refreshedToken)")
            self.firebasePushToken = refreshedToken
            UserDefaults.standard.set(refreshedToken, forKey: "firebaseToken")
            connectToFcm()
        }
    }
    
    func messageSuccessNotification(_ notification: Notification) {
       
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            }
            else {
                print("Connected to FCM.")
            }
        }
    }
    
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler()
    }
    
}

extension AppDelegate: FIRMessagingDelegate {
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
        if let notification = remoteMessage.appData as? [String: String] {
        
            print("••••••GOT NOTI•••••••")
            print("FIR messaging delegate remote message: \(notification)")
            if let messageType = notification["messageType"], messageType == "createCard" {
                print("messageType: " + messageType)
                if let navigationVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
                    let currentVC = navigationVC.visibleViewController as? NewCardViewController {
                    currentVC.back()
                }
                
                
                let localNotification = UILocalNotification()
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 3) as Date
                localNotification.alertBody = notification["statusMessage"]
                localNotification.timeZone = NSTimeZone.local
                localNotification.userInfo = ["Important":"Data"]
                localNotification.soundName = UILocalNotificationDefaultSoundName
                localNotification.applicationIconBadgeNumber = 5
                localNotification.category = "Message"
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }else if let messageType = notification["messageType"], messageType == "transactionData" {
                if let navigationVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let currentVC = navigationVC.visibleViewController as? PaymentPreviewViewController {
                    print("• Payment preview active")
                    if let trackingId = notification["trackId"] {
                        currentVC.pushToTransaction(trackingId: trackingId)
                    }
                }
            }
        }
        
    }
    
}

extension AppDelegate {
    
    func showLockScreen(){
        if let vc = self.getVisibleViewController() {
            if !(vc is LockViewController) && !(vc is SignInViewController) {
                if let lockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lockViewController") as? UINavigationController {
                    vc.present(lockVC, animated: true, completion: nil)
                }
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
