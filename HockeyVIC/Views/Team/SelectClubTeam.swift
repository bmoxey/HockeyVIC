//
//  SelectClubTeam.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI
import SwiftData
import AudioToolbox

struct SelectClubTeam: View {
    @EnvironmentObject var pathState: PathState
    @Environment(\.modelContext) var context
    var myTeam: String
    var teams: [Team]
    @Binding var stillLoading: Bool
    @Query var myteams: [Team]
    var body: some View {
        let filteredTeams = teams.filter { $0.clubName == myTeam }
        let groupedTeams = Dictionary(grouping: filteredTeams, by: { $0.type })
        List {
            ForEach(Array(groupedTeams.keys).sorted(), id: \.self) { type in
                let header = "\(myTeam) \(type) teams"
                Section(header: Text(header).foregroundStyle(Color("TextColor"))) {
                    ForEach(groupedTeams[type]!, id: \.id) { team in
                        HStack {
                            Text(team.type)
                            VStack(alignment: .leading) {
                                Text(team.divName)
                                    .foregroundStyle(Color("TextColor"))
                                if team.teamName != team.clubName {
                                    Text("competing as \(team.teamName)")
                                        .foregroundStyle(Color("TextColor"))
                                        .font(.footnote)
                                }
                            }
                            Spacer()
                                .overlay(
                                    Image(systemName: "return.left")
                                        .font(Font.system(size: 17, weight: .semibold))
                                        .foregroundColor(Color("AccentColor"))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.horizontal, -8)
                                )
                        }
                        .listRowBackground(Color("BackColor"))
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
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("ListColor"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Select your team")
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(.semibold)
                    Text(myTeam)
                        .foregroundStyle(Color("TextColor"))
                        .font(.footnote)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(myTeam)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .toolbarBackground(Color("BackColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}


#Preview {
    SelectClubTeam(myTeam: "", teams: [], stillLoading: .constant(true))
}
