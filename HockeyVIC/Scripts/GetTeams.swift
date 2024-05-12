//
//  GetTeams.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
func getTeams(myComp: Team) async -> [Team] {
    var teams: [Team] = []
    var lines: [String] = []
    lines = GetUrl(url: "https://revolutionise.com.au/\(myComp.assocCode)/pointscore/\(myComp.compID)/\(myComp.divID)")
    for i in 0 ..< lines.count {
        if lines[i].contains("/games/team/") {
            let bits = lines[i].split(separator: "/")
            if bits.count > 2 {
                let teamID = bits[bits.count - 1].trimmingCharacters(in: .punctuationCharacters)
                let teamName = ShortTeamName(fullName: lines[i+1])
                let clubName = GetClubName(teamName: teamName)
                teams.append(Team(assocName: myComp.assocName, assocCode: myComp.assocCode, compName: myComp.compName, compID: myComp.compID, divName: myComp.divName, divID: myComp.divID, teamName: teamName, teamID: teamID, clubName: clubName, type: myComp.type, isCurrent: false))
            }
        }
    }
    if teams.isEmpty {
        lines = GetUrl(url: "https://revolutionise.com.au/\(myComp.assocCode)/games/\(myComp.compID)/\(myComp.divID)/round/1")
        for i in 0 ..< lines.count {
            if lines[i].contains("/games/team/") {
                let bits = lines[i].split(separator: "/")
                if bits.count > 2 {
                    let teamID = bits[bits.count - 1].trimmingCharacters(in: .punctuationCharacters)
                    let teamName = ShortTeamName(fullName: lines[i+1])
                    let clubName = GetClubName(teamName: teamName)
                    teams.append(Team(assocName: myComp.assocName, assocCode: myComp.assocCode, compName: myComp.compName, compID: myComp.compID, divName: myComp.divName, divID: myComp.divID, teamName: teamName, teamID: teamID, clubName: clubName, type: myComp.type, isCurrent: false))
                }
            }
        }
    }
    return teams
}
