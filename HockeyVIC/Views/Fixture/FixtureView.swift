//
//  FixtureView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI
import SwiftData
import AudioToolbox

struct FixtureView: View {
    @Query var myteams: [Team]
    @State private var fixtures: [Fixture] = []
    @State private var haveData = false
    @State private var haveRound = false
    @State private var myRound: Round = Round()
    @State private var myPlayers: [Player] = []
    @State private var showTeamSelector = false
    @State var currentFixture: Fixture? = Fixture()
    @State var address: String = ""
    @State var searchTeam: String = ""
    @State private var showConfetti = false
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        NavigationStack() {
            VStack(spacing: 0) {
                if fixtures.isEmpty {
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
                                fixtures = await getFixtures(team: currentTeam)
                                let count = fixtures.filter { $0.date < Date() }.count
                                guard count < fixtures.count else { return }
                                DispatchQueue.main.async {
                                    withAnimation {
                                        currentFixture = fixtures[0]
                                        currentFixture = fixtures[count]
                                    }
                                }
                                haveData = true
                                haveRound = false
                            }
                        }
                    }
                } else {
                    SelectFixture(fixtures: $fixtures, currentFixture: $currentFixture)
                    List {
                        if currentFixture?.result == "BYE" {
                            ByeView(date: currentFixture?.date ?? Date(), team: currentTeam.teamName, myTeam: currentTeam.teamName)
                        } else {
                            if haveRound {
                                if currentFixture?.status == "Playing" {
                                    UpcomingFixture(game: myRound)
                                    GroundView(fixture: currentFixture, address: myRound.address)
                                } else {
                                    PlayedFixture(game: myRound)
                                    PlayersView(searchTeam: myRound.myTeam, myRound: $myRound, players: $myPlayers)
                                }
                            }
                        }
                    }
                    .onChange(of: currentFixture, {
                        Task {
                            haveRound = false
                            AudioServicesPlaySystemSound(1519)
                            if currentFixture?.result != "BYE" {
                                (myRound, myPlayers) = await getGame(fixture: currentFixture ?? Fixture())
                                if myRound.roundNo.contains("Grand Final") && myRound.result == "Win" {
                                    showConfetti = true
                                } else {
                                    showConfetti = false
                                }
                                haveRound = true
                            }
                        }
                    })
                }
            }
            .displayConfetti(isActive: $showConfetti)
            .onAppear {
                fixtures = []
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
                        fixtures = []
                        showTeamSelector = false
                    }
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, -4)
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
        }
    }
}


#Preview {
    FixtureView()
}
