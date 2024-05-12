//
//  CurrentTeams.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI
import SwiftData
import AudioToolbox

struct CurrentTeams: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Team.orderIndex) var myteams: [Team]
    var body: some View {
        Section (header: Text("My teams").foregroundStyle(Color("TextColor"))) {
            ForEach(myteams) { team in
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .onTapGesture {
                            if let index = myteams.firstIndex(of: team) {
                                if myteams[index].isCurrent {
                                    if let newCurrent = myteams.first(where: { !$0.isCurrent }) {
                                        newCurrent.isCurrent = true
                                    }
                                }
                                context.delete(myteams[index])
                                AudioServicesPlaySystemSound(1520)
                            }
                        }
                    Image(team.clubName)
                        .resizable()
                        .frame(width: 45, height: 45)
                    VStack (alignment: .leading) {
                        Text(team.teamName)
                            .foregroundStyle(team.isCurrent ? Color("NavyBlue") : Color("TextColor"))
                            .fontWeight(.semibold)
                        Text(team.divName)
                            .foregroundStyle(team.isCurrent ? Color("NavyBlue") : Color("TextColor"))
                            .font(.footnote)
                    }
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(Color.gray)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .listRowBackground(team.isCurrent ? Color("AccentColor") : Color("BackColor"))
                .onTapGesture {
                     for myteam in myteams { myteam.isCurrent = false }
                     team.isCurrent = true
                 }
            }
            .onMove { source, destination in
                var tempItems = myteams
                tempItems.move(fromOffsets: source, toOffset: destination)
                
                for (index, tempItem) in tempItems.enumerated() {
                    if let myteams = myteams.filter({ $0.id == tempItem.id}).first {
                        myteams.orderIndex = index
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    if myteams[index].isCurrent {
                        if let newCurrent = myteams.first(where: { !$0.isCurrent }) {
                            newCurrent.isCurrent = true
                        }
                    }
                    context.delete(myteams[index])
                    AudioServicesPlaySystemSound(1520)
                }
            }
        }
    }
}

#Preview {
    CurrentTeams()
}
