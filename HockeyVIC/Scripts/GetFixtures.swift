//
//  GetFixtures.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import Foundation
func getFixtures(team: Team) async -> [Fixture] {
    var fixtures: [Fixture] = []
    var myFixture: Fixture = Fixture()

    var lines: [String] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = " E dd MMM yyyy HH:mm "
    myFixture.myTeam = team.teamName
    lines = GetUrl(url: "https://revolutionise.com.au/\(team.assocCode)/games/team/\(team.compID)/\(team.teamID)")
    for i in 0 ..< lines.count - 2 {
        if let dateTime = dateFormatter.date(from: lines[i] + " " + lines[i+2]) {
            myFixture.date = dateTime
            myFixture.roundNo = lines[i-4]
        }
        if lines[i].contains("/venues/") {
            myFixture.venue = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
            myFixture.field = lines[i+5].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if lines[i].contains("Playing") { myFixture.status = "Playing" ; myFixture.result = "No Game" }
        if lines[i].contains("Played") { myFixture.status = "Played" }
        if lines[i].contains("have a BYE.") {
            myFixture.status = "Have a BYE"
            myFixture.result = "BYE"
            myFixture.opponent = "Nobody"
        }
        if lines[i].contains("/games/team/") { myFixture.opponent = ShortTeamName(fullName: lines[i+1]).trimmingCharacters(in: .whitespacesAndNewlines) }
        if lines[i] == "Draw" { myFixture.result = "Draw" }
        if lines[i] == "Win" { myFixture.result = "Win" }
        if lines[i] == "Loss" { myFixture.result = "Loss" }
        if lines[i].contains("/game/") {
            let bits = lines[i].split(separator: "/")
            if bits.count > 2 {
                myFixture.gameID = bits[bits.count - 1].trimmingCharacters(in: .punctuationCharacters)
                myFixture.id = UUID()
                myFixture.assocCode = team.assocCode
                if myFixture.result == "" && myFixture.status == "Played" {myFixture.result = "No Results"}
                fixtures.append(myFixture)
                myFixture = Fixture()
                myFixture.myTeam = team.teamName
            }
        }
    }

    return fixtures.sorted(by: { $0.date < $1.date })
}
