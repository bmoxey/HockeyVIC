//
//  ByeView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI

struct ByeView: View {
    let date: Date
    let team: String
    let myTeam: String
    var myLongDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    var body: some View {
        Section(header: Text("\(myLongDate)").foregroundStyle(Color("TextColor"))) {
            HStack {
                Spacer()
                Text("No game this round")
                    .frame(alignment: .center)
                    .foregroundStyle(Color("NavyBlue"))
                Spacer()
            }
            .listRowBackground(getColor(result: "BYE"))
            HStack {
                HStack {
                    Spacer()
                    VStack {
                        Image(GetClubName(teamName: team))
                            .resizable()
                            .frame(width: 75, height: 75)
                        Text("\(team)")
                            .foregroundStyle(Color("NavyBlue"))
                            .fontWeight(myTeam == team ? .bold : .regular)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    Spacer()
                }
                HStack {
                    Text("has a BYE")
                        .foregroundStyle(Color("NavyBlue"))
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
            .listRowBackground(getColor(result: "BYE").brightness(0.4))
            .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
        }
    }
}


#Preview {
    ByeView(date: Date(), team: "", myTeam: "")
}
