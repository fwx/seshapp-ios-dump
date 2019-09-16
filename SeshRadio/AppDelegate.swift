//
//  AppDelegate.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import FPSCounter
import SkeletonView
import RealmSwift
import Realm
import Sentry
import Firebase
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //FPSCounter.showInStatusBar(UIApplication.shared)
        SkeletonAppearance.default.tintColor = .navBarTint
        
        self.initSentry()
        self.createFolders()
        self.initRealm()
        self.registerForSettings()
        
        self.initFirebase(application: application)
        
        return true
    }
    
    func initSentry() {
        // Create a Sentry client and start crash handler
        do {
            Client.shared = try Client(dsn: "")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
    }
    
    func initRealm() {
       let config = Realm.Configuration(readOnly: false,
                                        schemaVersion: 1,
                                        migrationBlock: nil,
                                        deleteRealmIfMigrationNeeded: true,
                                        shouldCompactOnLaunch: nil,
                                        objectTypes: nil)
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    func createFolders() {
        let documents = CacheService.instance.getDocumentsDirectory()
        
        let musicDir = documents.appendingPathComponent("music")
        
        if !FileManager.default.fileExists(atPath: musicDir.path) {
            try? FileManager.default.createDirectory(at: musicDir, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func registerForSettings() {
        let defaults = UserDefaults.standard
        
        guard let settingsBundle = Bundle
            .main
            .url(forResource: "Root", withExtension: "plist", subdirectory: "Settings.bundle")
            else { return }
        
        
        guard let settings = NSDictionary(contentsOf: settingsBundle),
            let preferenced = settings["PreferenceSpecifiers"] as? [NSDictionary]
            else { return }
        
        var defaultsToReg: [String: Any] = [:]
        
        preferenced.forEach { (dict) in
            guard let key = dict["Key"] as? String else { return }
            guard let defaultValue = dict["DefaultValue"] else { return }
            defaultsToReg[key] = defaultValue
            print("\(key)=\(defaultValue)")
        }
        
        defaults.register(defaults: defaultsToReg)
        
        print("done")
    }
    
    func setupPushNotifications(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
    }

    private func initFirebase(application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.setupPushNotifications(application: application)
    }
    
}

/* App's Lifecycle */
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Globals.automaticallyCacheTracks = UserDefaults.standard.bool(forKey: Globals.SettingsBundleKeys.autoCache)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        
        PushService
            .registerToken(fcmToken)
            .do(onError: nil, afterError: nil, onCompleted: {
                print("token updated")
            }, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
        .subscribe(onCompleted: nil, onError: nil)
        
//        guard API.shared.isDemoAccess == false else { return }
//
//        _ = ProfileService
//            .fetchProfile()
//            .filter({ $0.getToken() != fcmToken })
//            .map({ (user) -> Completable in
//                return ProfileService
//                    .updateToken(fcmToken)
//            })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
            completionHandler([.alert, .badge, .sound])
            return
        }
        
        print("received userInfo: \(userInfo)")
        
        PushHelper
            .instance
            .acceptPush(by: userInfo, silent: true)
        
        
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.newData)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            completionHandler()
            return
        }
        
        // DATA
        // userInfo["category"] = string
        // userInfo["link"] = string/url
        
         print("received userInfo[2]: \(userInfo)")
        
        PushHelper
            .instance
            .acceptPush(by: userInfo)
        
        completionHandler()
        
    }
}
