//
//  SelectTeam.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI
import SwiftData

struct TeamView: View {
    @StateObject var pathState = PathState()
    @State private var teams: [Team] = []
    @Query(sort: \Team.orderIndex) var myteams: [Team]
    @State private var assocInfo: Bool = false
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        NavigationStack(path: $pathState.path) {
            List{
                if !myteams.isEmpty {
                    CurrentTeams()
                }
                Section (header: Text("Add teams...").foregroundStyle(Color("TextColor"))) {
                    HStack {
                        Spacer()
                        Text(currentAssoc.name)
                            .foregroundStyle(Color("NavyBlue"))
                        Image(systemName: "info.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .popover(isPresented: $assocInfo) {
                                AssocInfoView(assoc: currentAssoc)
                                    .background(Color("TextColor"))
                                    .presentationCompactAdaptation((.popover))
                                }
                        Spacer()
                    }
                    .onTapGesture {
                        assocInfo = true
                    }
                    .listRowBackground(Color("AccentColor"))
                    NavigationLink(value: PathState.Destination.getAssocs) {
                        HStack {
                            Image(currentAssoc.code)
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(.leading, -8)
                            Text("Change Hockey Association")
                        }
                    }
                    NavigationLink(value: PathState.Destination.getComps) {
                        HStack {
                            Image(systemName: "rectangle.stack.badge.plus")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color("AccentColor"), Color("TextColor"))
                            Text("Add team by division name")
                        }
                    }
                    NavigationLink(value: PathState.Destination.getClubs) {
                        HStack {
                            Image(systemName: "person.crop.rectangle.badge.plus")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color("AccentColor"), Color("TextColor"))
                            Text("Add team by club name")
                            if teams.isEmpty || (teams.first != nil && teams[0].assocCode != currentAssoc.code) {
                                Image(systemName: "externaldrive.badge.wifi")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color("AccentColor"), Color("TextColor"))
                            }                    }
                    }
                }
                .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                .listRowBackground(Color("BackColor"))
            }
            .navigationDestination(for: PathState.Destination.self) { destination in
                switch destination {
                    case .getAssocs: GetAssocView()
                    case .getComps: GetCompsView()
                    case .getClubs: GetClubsView(teams: $teams)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(myteams.isEmpty ? "Add your teams" : "Select and add teams")
                            .foregroundStyle(Color("TextColor"))
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.crop.circle.badge.questionmark.fill")
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
        .environmentObject(pathState)
        .accentColor(Color("AccentColor"))
    }
}

