//
//  PlayerView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import SwiftUI
import SwiftData

struct PlayerView: View {
    @Query var myteams: [Team]
    var player: Player
    @State var games: [Player] = []
    @State var totalGoals: Int = 0
    @State var totalCards: Int = 0
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        ForEach(games, id:\.id) {playerStat in
            HStack {
                Text("\(playerStat.name)")
                    .font(.subheadline)
                    .foregroundStyle(Color("TextColor"))
                if playerStat.fillin {
                    Image(systemName: "person.fill.badge.plus")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("AccentColor"))
                }
                Text("\(playerStat.date)")
                    .font(.subheadline)
                    .foregroundStyle(Color("TextColor"))
                if playerStat.goalie == 1 {
                    Text(" (GK)")
                        .font(.subheadline)
                        .foregroundStyle(Color("TextColor"))
                }
                if playerStat.greenCards > 0 {
                    Text(String(repeating: "▲", count: playerStat.greenCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.green)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                if playerStat.yellowCards > 0 {
                    Text(String(repeating: "■", count: playerStat.yellowCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.yellow)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                if playerStat.redCards > 0 {
                    Text(String(repeating: "●", count: playerStat.redCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.red)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                Spacer()
                if playerStat.goals > 0 {
                    Text(String(repeating: "●", count: playerStat.goals))
                        .font(.system(size:20))
                        .foregroundStyle(Color.green)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(nil)
                }
            }
            .listRowBackground(Color("BackColor").opacity(0.5))
        }
        .frame(height: 12)
        HStack {
            HStack {
                Text("Games:")
                    .foregroundStyle(Color("TextColor"))
                    .font(.subheadline)
                Text("\(player.numberGames)")
                    .foregroundStyle(Color("AccentColor"))
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                Spacer()
                if totalCards > 0 {
                    Text("Cards:")
                        .foregroundStyle(Color("TextColor"))
                        .font(.subheadline)
                    Text("\(totalCards)")
                        .foregroundStyle(Color("AccentColor"))
                        .font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Spacer()
                if totalGoals > 0 {
                    Text("Goals:")
                        .foregroundStyle(Color("TextColor"))
                        .font(.subheadline)
                    Text("\(totalGoals)")
                        .foregroundStyle(Color("AccentColor"))
                        .font(.subheadline)
                }
            }
        }
        .frame(height: 12)
        .listRowBackground(Color("ListColor"))
        .onAppear {
            Task {
                games = await getPlayer(player: player, team: currentTeam)
                totalGoals = games.reduce(0) { result, player in result + player.goals }
                totalCards = games.reduce(0) { result, player in result + player.greenCards + player.yellowCards + player.redCards }
            }
        }
    }
}

#Preview {
    PlayerView(player: Player())
}
