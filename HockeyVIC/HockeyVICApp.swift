//
//  HockeyVICApp.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI
import SwiftData

@main
struct HockeyVICApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(for: Team.self)
    }
}
