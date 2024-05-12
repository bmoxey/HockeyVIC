//
//  StatsDetail.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import SwiftUI

struct StatsDetail: View {
    @State var player: Player
    @State var selectedPlayer: Player = Player()
    var body: some View {
        HStack {
            if player.fillin {
                Image(systemName: "person.fill.badge.plus")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("TextColor"), Color("AccentColor"))
            } else {
                if player.numberGames == 0 {
                    Image(systemName: "person")
                        .foregroundStyle(Color("AccentColor"))
                } else {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color("AccentColor"))
                }
            }
            Text(player.name)
                .foregroundStyle(Color("TextColor"))
            if player.goalie > 0 {
                Text("(\(player.goalie)xGK)")
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
            Text("\(player.goals)")
                .frame(width: 30)
                .foregroundStyle(Color("TextColor"))
            Text("\(player.numberGames)")
                .frame(width: 30)
                .foregroundStyle(Color("TextColor"))
            Image(systemName: player == selectedPlayer ? "chevron.left" : "chevron.right")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor("\(player.numberGames)" == "0" ? Color.clear : Color("AccentColor"))
        }
        .listRowBackground(Color("BackColor"))
        .onTapGesture {
            if player.numberGames > 0 {
                if selectedPlayer == player {
                    selectedPlayer = Player()
                } else {
                    selectedPlayer = player
                }
            }
        }
        if selectedPlayer == player {
            PlayerView(player: player)
        }
    }
}

#Preview {
    StatsDetail(player: Player())
}
