//
//  GetCompsTeam.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI
import SwiftData
import AudioToolbox

struct SelectCompsTeam: View {
    @EnvironmentObject var pathState: PathState
    @Environment(\.modelContext) var context
    @State var myComp: Team
    @State var teams: [Team] = []
    @Query var myteams: [Team]
    var body: some View {
        List {
            if !teams.isEmpty {
                HStack {
                    Spacer()
                    Text(myComp.type)
                    Text(myComp.divName)
                        .foregroundStyle(Color("NavyBlue"))
                    Spacer()
                }
                .listRowBackground(Color("AccentColor"))
                
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 10) {
                    ForEach(teams, id: \.id) { team in
                        VStack {
                            Image(team.clubName)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                            Text(team.teamName)
                                .font(.footnote)
                                .foregroundStyle(Color("TextColor"))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            for myteam in myteams { myteam.isCurrent = false }
                            if let _foundTeam = myteams.first(where: {$0.teamID == team.teamID}) {
                                _foundTeam.isCurrent = true
                            } else {
                                team.isCurrent = true
                                context.insert(team)
                            }
                            AudioServicesPlaySystemSound(1519)
                            pathState.path = []
                        }
                    }
                }
                .listRowBackground(Color("BackColor"))
            }

        }
        .scrollContentBackground(.hidden)
        .background(Color("ListColor"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Your Team")
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
            teams = await getTeams(myComp: myComp)
        }
    }
}

#Preview {
    SelectCompsTeam(myComp: Team())
}
