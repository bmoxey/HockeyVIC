//
//  MainMenu.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI

struct MainMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedIndex = 0
    var body: some View {
        let col = colorScheme == .dark ? Color("BackColor") : Color("TextColor")
        TabView(selection: $selectedIndex) {
             FixtureView()
                 .onAppear { selectedIndex = 0 }
                 .tabItem {
                     Image(systemName: "calendar.badge.clock")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 0 ? Color("AccentColor") : .gray , selectedIndex == 0 ? col : .gray)
                     Text("Fixture")
                 }
                 .tag(0)
                 .toolbarBackground(Color("BackColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             LadderView()
                 .onAppear {
                     selectedIndex = 1
                 }
                 .tabItem {
                     Image(systemName: "list.number")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 1 ? Color("AccentColor") : .gray , selectedIndex == 1 ? col : .gray)
                     Text("Ladder")
                 }
                 .tag(1)
                 .toolbarBackground(Color("BackColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             RoundView()
                 .onAppear {
                     selectedIndex = 2
                 }
                 .tabItem {
                     Image(systemName:  "clock.badge.fill")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 2 ? Color("AccentColor") : .gray , selectedIndex == 2 ? col : .gray)
                     Text("Round")
                 }
                 .tag(2)
                 .toolbarBackground(Color("BackColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             StatisticsView()
                 .onAppear {
                     selectedIndex = 3
                 }
                 .tabItem {
                     Image(systemName: "chart.bar.xaxis")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 3 ? col : .gray, selectedIndex == 3 ? Color("AccentColor") : .gray)
                     Text("Stats")
                 }
                 .tag(3)
                 .toolbarBackground(Color("BackColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             TeamView()
                 .onAppear {
                     selectedIndex = 4
                 }
                 .tabItem {
                     Image(systemName: "person.crop.circle.badge.questionmark.fill")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 4 ? Color("AccentColor") : .gray , selectedIndex == 4 ? col : .gray)
                     Text("Teams")
                 }
                 .tag(4)
                 .toolbarBackground(Color("BackColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
         }
        .accentColor(Color("TextColor"))
     }
}

#Preview {
    MainMenu()
}
