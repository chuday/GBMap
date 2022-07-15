//
//  AppDelegate.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 28.06.2022.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("key")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        requestPermission(center: center)
        
        return true
    }
    
    func requestPermission(center: UNUserNotificationCenter) {
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [ weak self ] granted, error in
            guard granted else {
                print("permission not granted")
                return
            }
            
            guard let self = self else { return }
            
            let content = self.createContent()
            
            let trigger = self.createTrigger()
            
            self.sendNotificationRequest(content: content, trigger: trigger)
        }
    }
    
    func createContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.subtitle = "Open the app"
        content.body = "Follow the white rabbit"
        content.userInfo = ["message": "Hello there"]
        content.badge = 3
        
        return content
    }
    
    func createTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    }
    
    func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(identifier: "timeNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        let title = response.notification.request.content.title
        let userInfo = response.notification.request.content.userInfo
        
        print(title)
        
        if let message = userInfo["message"] as? String {
            print("Message: \(message)")
        }
    }
}

