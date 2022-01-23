//
//  Dday_SwiftUIApp.swift
//  WatchDday WatchKit Extension
//
//  Created by Seongheon Park on 2022/01/21.
//  Copyright © 2022 n30gu1. All rights reserved.
//

import SwiftUI
import ClockKit

@main
struct Dday_SwiftUIApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    override init(){
        super.init()
    }
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("applicationDidFinishLaunching for watchOS")
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: Date(),
            userInfo: nil
        ) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Scheduled!")
                let server = CLKComplicationServer.sharedInstance()
                if let complications = server.activeComplications {
                    for complication in complications {
                        server.reloadTimeline(for: complication)
                    }
                }
            }
        }
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for backgroundTask in backgroundTasks {
            let server = CLKComplicationServer.sharedInstance()
            if let complications = server.activeComplications {
                for complication in complications {
                    server.reloadTimeline(for: complication)
                }
            }
            WKExtension.shared().scheduleBackgroundRefresh(
                withPreferredDate: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date().addingTimeInterval(86400))!,
                userInfo: nil
            ) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Scheduled!")
                }
            }
            backgroundTask.setTaskCompletedWithSnapshot(true)
        }
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
}
