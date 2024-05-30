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
                        VStack {
                            Text("Goals")
                            Text("for-agst=dif")
                        }
                            .frame(width: 80, alignment: .center)
                        Text("Pld")
                            .frame(width: 40, alignment: .center)
                        Text("Pts")
                            .frame(width: 40, alignment: .center)
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
                            
                            Image(GetClubName(teamName: item.teamName))
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding(.vertical, -4)
                            VStack {
                                HStack {
                                    Image(systemName: item.teamName == currentTeam.teamName ? "\(item.pos).circle.fill" : "\(item.pos).circle")
                                        .padding(.leading, 8)
                                    Text("\(item.teamName)")
                                        .font(.footnote)
                                        .foregroundStyle(Color("AccentColor"))
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("\(item.scoreFor)-\(item.scoreAgainst)=\(item.diff)")
                                        .frame(width: 80, alignment: .center)
                                    Text("\(item.played)")
                                        .frame(width: 40, alignment: .center)
                                    Text("\(item.points)")
                                        .frame(width: 40, alignment: .center)
                                    if item.winRatio != "" {
                                        Text("\(item.winRatio)")
                                            .frame(width: 60, alignment: .center)
                                    }
                                }
                            }
                        }
                        .fontWeight(item.teamName == currentTeam.teamName ? .bold : .regular)
                        .listRowSeparatorTint( item.pos == 4 ? Color("TextColor") : Color(UIColor.separator), edges: .all)
                        .listRowBackground(item.teamName == currentTeam.teamName ? Color("BackColor").opacity(0.5) : Color("BackColor"))
                    }
                    .foregroundStyle(Color("TextColor"))
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
