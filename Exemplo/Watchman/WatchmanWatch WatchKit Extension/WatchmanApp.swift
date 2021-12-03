//
//  WatchmanApp.swift
//  WatchmanWatch WatchKit Extension
//
//  Created by Pedro Henrique on 02/12/21.
//

import SwiftUI

@main
struct WatchmanApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
