//
//  NotificationViewModel.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import Foundation
import UserNotifications
import PushKit
import UIKit
import SwiftUI

class NotificationViewModel: NSObject, ObservableObject {
    
    static let shared = NotificationViewModel()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func buildAndSendLocalNotification(with title: String, subtitle: String, body: String, and sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func scheduleLocalNotification(with title: String, subtitle: String, body: String, and sound: UNNotificationSound = .default) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] authorized, error in
            if authorized {
                self?.buildAndSendLocalNotification(with: title, subtitle: subtitle, body: body, and: sound)
            }
        }
        
    }
    
}

extension NotificationViewModel: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            print("Usuário abriu uma notificação push: \(response.notification.request.content.title)")
        }else {
            print("Usuário abriu uma notificação local: \(response.notification.request.content.title)")
        }
        completionHandler()
    }
    
}

extension NotificationViewModel: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map({String(format: "%02.2hhx", $0)})
        let token = tokenParts.joined()
        print("Device token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Deu erro: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Chegou a notificação: \(userInfo)")
        completionHandler(.noData)
    }
    
}
