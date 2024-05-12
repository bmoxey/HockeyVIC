//
//  LadderView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI
import SwiftData

struct LadderView: View {
    @Query var myteams: [Team]
    @State var ladder = [LadderItem]()
    @State var haveData = false
    @State private var showTeamSelector = false
    var body: some View {
        let currentTeam: Team = myteams.first(where: { $0.isCurrent }) ?? Team(clubName: currentAssoc.code)
        NavigationStack() {
            List {
                if ladder.isEmpty {
                    if haveData {
                        Text("No Data!")
                            .listRowBackground(Color("BackColor"))
                    } else {
                        Text("Loading...")
                            .listRowBackground(Color("BackColor"))
                            .onAppear {
                                Task {
                                    ladder = await getLadder(myTeam: currentTeam)
                                    haveData = true
                                }
                            }
                    }
                } else {
                    HStack {
                        Text("Team")
                            .font(.footnote)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Text("GF")
                            .frame(width: 40, alignment: .trailing)
                        Text("GA")
                            .frame(width: 40, alignment: .trailing)
                        Text("GD")
                            .frame(width: 40, alignment: .trailing)
                        Text("Pts")
                            .frame(width: 40, alignment: .trailing)
                        if ladder[0].winRatio != "" {
                            Text("WR")
                                .frame(width: 60, alignment: .center)
                        }
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("NavyBlue"))
                    .listRowBackground(Color("AccentColor"))
                    ForEach(ladder, id:\.id) {item in
                        HStack {
                            Image(systemName: item.teamName == currentTeam.teamName ? "\(item.pos).circle.fill" : "\(item.pos).circle")
                            Image(GetClubName(teamName: item.teamName))
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding(.vertical, -4)
                            VStack {
                                HStack {
                                    Text("\(item.teamName)")
                                        .font(.footnote)
                                        .foregroundStyle(Color("AccentColor"))
                                        .padding(.leading, 8)
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("\(item.scoreFor)")
                                        .frame(width: 40, alignment: .trailing)
                                    Text("\(item.scoreAgainst)")
                                        .frame(width: 40, alignment: .trailing)
                                    Text("\(item.diff)")
                                        .frame(width: 40, alignment: .trailing)
                                    Text("\(item.points)")
                                        .frame(width: 40, alignment: .trailing)
                                    if item.winRatio != "" {
                                        Text("\(item.winRatio)")
                                            .frame(width: 60, alignment: .trailing)
                                    }
                                }
                            }
                        }
                        .fontWeight(item.teamName == currentTeam.teamName ? .bold : .regular)
                        .listRowSeparatorTint( item.pos == 4 ? Color("TextColor") : Color(UIColor.separator), edges: .all)
                    }
                    .foregroundStyle(Color("TextColor"))
                    .listRowBackground(Color("BackColor"))
                }
            }
            .onAppear {
                ladder = []
                haveData = false
            }
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Current Ladder")
                                .foregroundStyle(Color("TextColor"))
                                .fontWeight(.semibold)
                            if myteams.count > 1 {
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color("AccentColor"))
                            }
                        }
                        Text(currentTeam.divName)
                            .foregroundStyle(Color("TextColor"))
                            .font(.footnote)
                    }
                    .onTapGesture {
                        if myteams.count > 1 {
                            showTeamSelector = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "list.number")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("AccentColor"), Color("TextColor"))
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentTeam.clubName)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbarBackground(Color("BackColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .foregroundStyle(Color("TextColor"))
        .accentColor(Color("AccentColor"))
        .CustomTeamSelector(isPresented: $showTeamSelector) {
            List {
                CurrentTeams()
                    .onChange(of: currentTeam.teamID) { oldValue, newValue in
                        haveData = false
                        ladder = []
                        showTeamSelector = false
                    }
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, -4)
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
        }
    }
}


#Preview {
    LadderView()
}
