//
//  GetLadder.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
func getLadder(myTeam: Team) async -> [LadderItem] {
    var myLadder = LadderItem()
    var ladder = [LadderItem]()
    var lines: [String] = []
    var pos = 0
    var team = 0
    var played = 0
    var wins = 0
    var draws = 0
    var losses = 0
    var byes = 0
    var goalsfor = 0
    var goalsagainst = 0
    var goaldiff = 0
    var points = 0
    var wr = 0
    lines = GetUrl(url: "https://revolutionise.com.au/\(myTeam.assocCode)/pointscore/" + myTeam.compID + "/" + myTeam.divID)
    for i in 0 ..< lines.count {
        if String(lines[i]) == "Team" {team = i}
        if String(lines[i]) == "Played" {played = i}
        if String(lines[i]) == "Wins" {wins = i}
        if String(lines[i]) == "Draws" {draws = i}
        if String(lines[i]) == "Losses" {losses = i}
        if String(lines[i]) == "BYEs" {byes = i}
        if String(lines[i]) == "For" {goalsfor = i}
        if String(lines[i]) == "Against" {goalsagainst = i}
        if String(lines[i]) == "Diff." {goaldiff = i}
        if String(lines[i]) == "Points" {points = i}
        if String(lines[i]) == "WR" || String(lines[i]) == "WR*" {wr = i}
        if lines[i].contains("/games/team/") {
            pos += 1
            myLadder.teamID = String(String(lines[i]).split(separator: "/")[4]).trimmingCharacters(in: .punctuationCharacters)
            myLadder.compID = String(String(lines[i]).split(separator: "/")[3])
            myLadder.teamName = ShortTeamName(fullName: lines[i+1])
            myLadder.played = Int(lines[i+played-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.wins = Int(lines[i+wins-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.draws = Int(lines[i+draws-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.losses = Int(lines[i+losses-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.byes = Int(lines[i+byes-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.scoreFor = Int(lines[i+goalsfor-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.scoreAgainst = Int(lines[i+goalsagainst-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.diff = Int(lines[i+goaldiff-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myLadder.points = Int(lines[i+points-team+3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            if wr > 0 {
                myLadder.winRatio = String(lines[i+wr-team+5]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            myLadder.pos = pos
            myLadder.id = UUID()
            ladder.append(myLadder)
        }
    }
    return ladder
}
