//
//  PlayersView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI

struct PlayersView: View {
    @State var searchTeam: String
    @Binding var myRound: Round
    @Binding var players: [Player]
    var body: some View {
        if !players.isEmpty {
            Section(header: Text("Players").foregroundStyle(Color("TextColor"))) {
                Picker("Team:", selection: $searchTeam) {
                    Text(myRound.homeTeam)
                        .tag(ShortTeamName(fullName: myRound.homeTeam))
                    Text(myRound.awayTeam)
                        .tag(ShortTeamName(fullName: myRound.awayTeam))
                }
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("AccentColor"))
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("NavyBlue"))], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("TextColor"))], for: .normal)
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowBackground(Color("BackColor"))
                ForEach(players.sorted(by: { $0.surname < $1.surname }), id: \.id) {player in
                    if player.team == searchTeam {
                        HStack {
                            if player.fillin {
                                Image(systemName: "person.fill.badge.plus")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                            } else {
                                if player.captain {
                                    Image(systemName: "person.wave.2.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color("AccentColor"), Color("TextColor"))
                                } else {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color("AccentColor"))
                                }
                            }
                            Text(player.name)
                                .foregroundStyle(Color("TextColor"))
                            if player.goalie == 1 {
                                Text("(GK)")
                                    .foregroundStyle(Color("TextColor"))
                            }
                            if player.greenCards > 0 {
                                Text(String(repeating: "▲", count: player.greenCards))
                                    .font(.system(size:24))
                                    .foregroundStyle(Color.green)
                                    .padding(.vertical, 0)
                                    .padding(.horizontal, 0)
                            }
                            if player.yellowCards > 0 {
                                Text(String(repeating: "■", count: player.yellowCards))
                                    .font(.system(size:24))
                                    .foregroundStyle(Color.yellow)
                                    .padding(.vertical, 0)
                                    .padding(.horizontal, 0)
                            }
                            if player.redCards > 0 {
                                Text(String(repeating: "●", count: player.redCards))
                                .font(.system(size:24))
                                .foregroundStyle(Color.red)
                                .padding(.vertical, 0)
                                .padding(.horizontal, 0)
                            }
                            Spacer()
                            if player.goals > 0 {
                                Text(String(repeating: "●", count: player.goals))
                                .font(.system(size:20))
                                .foregroundStyle(Color.green)
                                .padding(.vertical, 0)
                                .padding(.horizontal, 0)
                            }
                        }
                        .listRowBackground(Color("BackColor"))
                    }
                }
            }
            .onChange(of: myRound) {
                searchTeam = myRound.myTeam
            }
        }
    }
}


#Preview {
    PlayersView(searchTeam: "", myRound: .constant(Round()), players: .constant([]))
}
