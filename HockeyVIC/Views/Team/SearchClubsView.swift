//
//  SearchClubsView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI

struct SearchClubsView: View {
    @Binding var teams: [Team]
    var comps: [Team]
    @Binding var stillLoading: Bool
    @State private var searchComp: String = ""
    @State private var searchDiv: String = ""
    @State private var divsFound: Int = 0
    @State private var totalDivs: Int = 0
    @State private var teamsFound: Int = 0
    var body: some View {
        VStack {
             Image("HVText")
                 .resizable()
                 .frame(width: 150, height: 50)
                 .padding()
             Image("HVPlayer")
                 .resizable()
                 .frame(width: 200, height: 234)
             Text(" ")
             Text(searchDiv)
                 .foregroundStyle(Color("TextColor"))
             HStack {
                 Text("Teams found: ")
                     .foregroundStyle(Color("TextColor"))
                 Text("\(teamsFound)")
                     .foregroundStyle(Color("AccentColor"))
             }
             Text(" ")
             ProgressView("Searching website for teams...",value: Double(divsFound), total: Double(totalDivs))
                 .foregroundStyle(Color("TextColor"))
                 .padding(.horizontal)
                 .padding(.bottom, 20)
             Text(" ")
         }
         .navigationBarBackButtonHidden(true)
         .frame(maxWidth: .infinity)
         .background(Color("BackColor"))
         .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
         .onAppear() {
             Task {
                 await GetTeams()
             }
         }
     }
     func GetTeams() async {
         stillLoading = true
         var lines: [String] = []
         totalDivs = comps.count
         for selectedComp in comps {
             searchComp = selectedComp.compName
             searchDiv = selectedComp.divName
             divsFound += 1
             lines = GetUrl(url: "https://revolutionise.com.au/\(currentAssoc.code)/pointscore/" + selectedComp.compID + "/" + selectedComp.divID)
             for i in 0 ..< lines.count {
                 if lines[i].contains("/games/team/") {
                     teamsFound += 1
                     let bits = String(lines[i]).split(separator: "/")
                     if bits.count > 2 {
                         let teamID = String(bits[bits.count-1]).trimmingCharacters(in: .punctuationCharacters)
                         let compID = String(bits[bits.count-2]).trimmingCharacters(in: .punctuationCharacters)
                         let teamName = ShortTeamName(fullName: lines[i+1])
                         let clubName = GetClubName(teamName: teamName)
                         teams.append(Team(assocName: selectedComp.assocName, assocCode: selectedComp.assocCode, compName: selectedComp.compName, compID: compID, divName: selectedComp.divName, divID: selectedComp.divID, teamName: teamName, teamID: teamID, clubName: clubName, type: selectedComp.type, isCurrent: false))
                     }
                 }
             }
         }
         stillLoading = false
     }
 }

#Preview {
    SearchClubsView(teams: .constant([]), comps: [], stillLoading: .constant(true))
}
