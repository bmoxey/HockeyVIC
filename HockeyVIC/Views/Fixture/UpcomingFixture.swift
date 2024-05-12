//
//  UpcomingFixture.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI

struct UpcomingFixture: View {
    var game: Round
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer? = nil
    var myLongDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return dateFormatter.string(from: game.date)
    }
    var body: some View {
        Section(header: Text("\(myLongDate)").foregroundStyle(Color("TextColor"))) {
            HStack {
                Spacer()
                if timeRemaining < 0 {
                    Text("Game has started")
                        .frame(alignment: .center)
                        .foregroundStyle(Color("NavyBlue"))
                } else {
                    Text("\(countdownString(timeRemaining: timeRemaining))")
                        .frame(alignment: .center)
                        .foregroundStyle(Color("NavyBlue"))
                }
                Spacer()
            }
            .listRowBackground(Color("AccentColor"))
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
                        DateBoxView(date: game.date, fullDate: false)
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
            .listRowBackground(Color("BackColor"))
            .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
        }
        .onAppear {
            timeRemaining = game.date.timeIntervalSinceNow
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                timeRemaining = game.date.timeIntervalSinceNow
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

#Preview {
    UpcomingFixture(game: Round())
}
