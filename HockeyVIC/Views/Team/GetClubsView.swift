//
//  GetClubsView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI

struct GetClubsView: View {
    @Binding var teams: [Team]
    @State private var stillLoading = false
    @State private var comps: [Team] = []
    var body: some View {
        List {
            if !teams.isEmpty && !stillLoading {
                let uniqueClubs = Array(Set(teams.map { $0.clubName }))
                ForEach(uniqueClubs.sorted(), id: \.self) { club in
                    NavigationLink(destination: SelectClubTeam(myTeam: club, teams: teams, stillLoading: $stillLoading)) {
                        HStack {
                            Image(GetClubName(teamName: club))
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding(.vertical, -4)
                            Text(club)
                                .foregroundStyle(Color("TextColor"))
                            Spacer()
                        }
                    }
                    .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                    .listRowBackground(Color("BackColor"))
                }
            } else {
                if !comps.isEmpty {
                    SearchClubsView(teams: $teams, comps: comps, stillLoading: $stillLoading)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("ListColor"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(!teams.isEmpty && !stillLoading ? "Select your club" : "Searching ...")
                    .foregroundStyle(Color("TextColor"))
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(currentAssoc.code)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .toolbarBackground(Color("BackColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            if !teams.isEmpty {
                if teams[0].assocCode != currentAssoc.code {
                    teams = []
                } else {
                    stillLoading = false
                }
            }
            comps = await getComps(assoc: currentAssoc)
        }
    }
}

#Preview {
    GetClubsView(teams: .constant([]))
}
