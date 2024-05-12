//
//  ContentView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var teams: [Team]
    var body: some View {
        if teams.isEmpty {
            TeamView()
        } else {
            MainMenu()
        }
    }
}

#Preview {
    ContentView()
}
