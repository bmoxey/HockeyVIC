//
//  GameView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import SwiftUI

struct GameView: View {
    var game: Round
    var myTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: game.date)
    }
    var body: some View {
        HStack {
            HStack {
                Spacer()
                VStack {
                    Image(GetClubName(teamName: game.homeTeam))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(game.homeTeam)")
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(game.homeTeam == game.myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
            HStack {
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "sportscourt")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                            .foregroundStyle(Color("TextColor"))
                        Text("\(game.field)")
                            .foregroundStyle(Color("TextColor"))
                    }
                    if game.result == "No Game" {
                        DateBoxView(date: game.date, fullDate: false)
                    } else {
                        HStack {
                            Text("\(game.homeGoals)")
                                .foregroundStyle(Color("TextColor"))
                                .fontWeight(game.homeTeam == game.myTeam ? .bold : .regular)
                                .font(.largeTitle)
                            Text(game.result == "No Results" ? myTime : "-")
                                .foregroundStyle(Color("TextColor"))
                            Text("\(game.awayGoals)")
                                .font(.largeTitle)
                                .fontWeight(game.awayTeam == game.myTeam ? .bold : .regular)
                                .foregroundStyle(Color("TextColor"))
                        }
                        Text(" \(game.result) ")
                            .foregroundStyle(Color("AccentColor"))
                    }
                }
            }
            HStack {
                Spacer()
                VStack {
                    Image(GetClubName(teamName: game.awayTeam))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(game.awayTeam)")
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(game.awayTeam == game.myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
        }
        .listRowSeparatorTint(Color("TextColor"), edges: .all)
        .listRowBackground(Color("BackColor"))
        .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))

    }
}

#Preview {
    GameView(game: Round())
}
