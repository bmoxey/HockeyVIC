//
//  GameByeView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import SwiftUI

struct GameByeView: View {
    let date: Date
    let team: String
    let myTeam: String
    var body: some View {
        HStack {
            HStack {
                Spacer()
                VStack {
                    Image(GetClubName(teamName: team))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(team)")
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(myTeam == team ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
            HStack {
                Text("has a BYE")
                    .foregroundStyle(Color("TextColor"))
            }
            HStack {
                Spacer()
                Text("\(team)")
                    .foregroundStyle(Color.clear)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer()
            }
        }
        .listRowBackground(Color("BackColor"))
        .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))

    }
}

#Preview {
    GameByeView(date: Date(), team: "", myTeam: "")
}
