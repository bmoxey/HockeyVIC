//
//  StatisticsView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query var myteams: [Team]
    @State var haveData = false
    @State private var players: [Player] = []
    @State private var sortedByName = true
    @State private var sortedByNameValue: KeyPath<Player, String> = \Player.surname
    @State private var sortedByValue: KeyPath<Player, Int>? = nil
    @State private var sortAscending = true
    @State private var sortMode = 2
    @State private var showModifierDialog = false
    @State private var count = 0
    @State private var total = 0
    @State private var showTeamSelector = false
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        NavigationStack {
            List {
                if players.isEmpty {
                    if haveData {
                        Text("No Data!")
                            .listRowBackground(Color("BackColor"))
                    } else {
                        Text("Loading ...")
                            .listRowBackground(Color("BackColor"))
                            .onAppear {
                                Task {
                                    await getPlayers(currentTeam: currentTeam)
                                    haveData = true
                                }
                            }
                    }
                } else {
                    StatsHeader(sortMode: $sortMode, sortAscending: $sortAscending, sortedByName: $sortedByName, sortedByNameValue: $sortedByNameValue, sortedByValue: $sortedByValue)
                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    ForEach(players.sorted(by: sortDescriptor)) { player in
                        StatsDetail(player: player)
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        
                    }
                    .environment(\.defaultMinListRowHeight, 12)
                    .scrollContentBackground(.hidden)
                }
            }
            .onAppear {
                players = []
                haveData = false
            }
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Player Statistics")
                                .foregroundStyle(Color("TextColor"))
                                .fontWeight(.semibold)
                            if myteams.count > 1 {
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color("AccentColor"))
                            }
                        }
                        Text(currentTeam.divName)
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                    }
                    .onTapGesture {
                        if myteams.count > 1 {
                            showTeamSelector = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chart.bar.xaxis")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentTeam.clubName)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbarBackground(Color("BackColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .foregroundStyle(Color("TextColor"))
        .accentColor(Color("AccentColor"))
        .CustomTeamSelector(isPresented: $showTeamSelector) {
            List {
                CurrentTeams()
                    .onChange(of: currentTeam.teamID) { oldValue, newValue in
                        haveData = false
                        players = []
                        showTeamSelector = false
                    }
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, -4)
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
        }
    }
    private var sortDescriptor: (Player, Player) -> Bool {
        let ascending = sortAscending
        if let sortedByValue = sortedByValue {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByValue] < player2[keyPath: sortedByValue]
                } else {
                    return player1[keyPath: sortedByValue] > player2[keyPath: sortedByValue]
                }
            }
        } else if sortedByName {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByNameValue] < player2[keyPath: sortedByNameValue]
                } else {
                    return player1[keyPath: sortedByNameValue] > player2[keyPath: sortedByNameValue]
                }
            }
        } else {
            return { _, _ in true }
        }
    }
    
    func getPlayers(currentTeam: Team) async {
        var myPlayer = Player()
        var lines: [String] = []
        var fillins: Bool = false
//        var games: [Player] = []
        lines = GetUrl(url: "https://revolutionise.com.au/\(currentTeam.assocCode)/games/team-stats/" + currentTeam.compID + "?team_id=" + currentTeam.teamID)
        total = lines.filter { $0.contains("/games/statistics/") }.count
        count = 0
        for i in 0 ..< lines.count {
            if lines[i].contains("Fill ins") { fillins = true }
            if lines[i].contains("/games/statistics/") {
                if lines[i+1].contains(" (fill-in)") {
                    fillins = true
                    lines[i+1] = lines[i+1].replacingOccurrences(of: " (fill-in)", with: "")
                }
                myPlayer.id = UUID()
                myPlayer.statsLink = String(lines[i].split(separator: "\"")[1])
                myPlayer.fillin = fillins
                myPlayer.name = ""
                myPlayer.surname = ""
                myPlayer.captain = false
                (myPlayer.name, myPlayer.surname, myPlayer.captain) = FixName(fullname: lines[i+1].capitalized.trimmingCharacters(in: CharacterSet.letters.inverted))
                myPlayer.numberGames = Int(lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                myPlayer.goals = Int(lines[i+11].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                myPlayer.greenCards = Int(lines[i+15].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                myPlayer.yellowCards = Int(lines[i+19].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                myPlayer.redCards = Int(lines[i+23].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                myPlayer.goalie = Int(lines[i+27].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                players.append(myPlayer)
                myPlayer = Player()
                fillins = false
                count = count + 1
            }
        }
    }
}


#Preview {
    StatisticsView()
}
