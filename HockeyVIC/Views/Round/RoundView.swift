//
//  RoundView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI
import SwiftData
import AudioToolbox

struct RoundView: View {
    @Query var myteams: [Team]
    @State private var rounds: [Rounds] = []
    @State private var haveData = false
    @State private var haveRound = false
    @State private var myRound: [Round] = []
    @State private var byeTeams: [String] = []
    @State var count: Int = 0
    @State var currentRound: Rounds?
    @State private var showTeamSelector = false
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        NavigationStack() {
            VStack(spacing: 0) {
                if rounds.isEmpty {
                    if haveData {
                        List {
                            Text("No Data!")
                                .listRowBackground(Color("BackColor"))
                        }
                    } else {
                        List {
                            Text("Loading ...")
                                .listRowBackground(Color("BackColor"))
                        }
                        .onAppear {
                            Task {
                                rounds = await getRounds(team: currentTeam)
                                count = 0
                                for round in rounds {
                                    if round.lastdate < Date() { count += 1 }
                                }
                                guard count < rounds.count else { return }
                                DispatchQueue.main.async {
                                    withAnimation {
                                        if !rounds.isEmpty {
                                            currentRound = rounds[count]
                                        }
                                    }
                                }
                                haveRound = false
                                haveData = true
                            }
                        }
                    }
                } else {
                    SelectRound(rounds: $rounds, currentRound: $currentRound)
                    List {
                        ForEach(groupedRounds, id: \.0) { date, roundsInSection in
                            Section(header: Text(dateString(from: date)).foregroundStyle(Color("TextColor"))) {
                                ForEach(roundsInSection) { game in
                                    GameView(game: game)
                                }
                            }
                        }
                        if !byeTeams.isEmpty {
                            Section(header: Text("No game this round").foregroundStyle(Color("TextColor"))) {
                                ForEach(byeTeams, id: \.self) { team in
                                    GameByeView(date: currentRound?.lastdate ?? Date(), team: team, myTeam: currentTeam.teamName)
                                }
                            }
                        }
                    }
                    .onChange(of: currentRound, {
                        Task {
                            haveRound = false
                            AudioServicesPlaySystemSound(1519)
                            if currentRound?.result != "BYE" {
                                (myRound, byeTeams) = await getRound(team: currentTeam, currentRound: currentRound ?? Rounds())
                                haveRound = true
                            }
                        }
                    })
                }
            }
            .onAppear {
                rounds = []
                haveData = false
                haveRound = false
            }
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Team Fixture")
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
                    Image(systemName: "calendar.badge.clock")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("AccentColor"), Color("TextColor"))
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
                        haveRound = false
                        rounds = []
                        showTeamSelector = false
                    }
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, -4)
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
        }
    }
    var groupedRounds: [(Date, [Round])] {
        let groupedDictionary = Dictionary(grouping: myRound) { game in
            Calendar.current.startOfDay(for: game.date)
        }
        return groupedDictionary.sorted { $0.key < $1.key }
    }
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RoundView()
}
