//
//  GetRound.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
func getRound(team: Team, currentRound: Rounds) async ->  ([Round], [String]) {
    var myRound: Round = Round()
    var rounds: [Round] = []
    var scores: String = ""
    var byeTeams = [String]()
    var byes = false
    var lines: [String] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E dd MMM yyyy HH:mm"
    lines = GetUrl(url: "https://revolutionise.com.au/\(team.assocCode)/games/\(team.compID)/\(team.divID)/round/\(currentRound.roundNum)")
    for i in 0 ..< lines.count - 2 {
        if lines[i].contains("BYEs") { byes = true }
        if let dateTime = dateFormatter.date(from: lines[i].trimmingCharacters(in: .whitespacesAndNewlines) + " " + lines[i+2].trimmingCharacters(in: .whitespacesAndNewlines)) {
            myRound.date = dateTime
        }
        if lines[i].contains("/venues/") {
            myRound.venue = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
            myRound.field = lines[i+5].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if lines[i].contains("/games/team/") || lines[i].contains("/teams/") {
            if byes {
                byeTeams.append(ShortTeamName(fullName: lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)))
            } else {
                if myRound.homeTeam == "" {
                    myRound.homeTeam = ShortTeamName(fullName: lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines))
                    scores = lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)
                    if lines[i+5].trimmingCharacters(in: .whitespacesAndNewlines) == "vs" {
                        myRound.result = "No Game"
                    }
                } else {
                    if myRound.awayTeam == "" {
                        myRound.awayTeam = ShortTeamName(fullName: lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines))
                        (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "-")
                        if myRound.result != "No Game" {
                            if myRound.homeGoals == myRound.awayGoals {
                                myRound.result = "drew with"
                            } else {
                                if Int(myRound.homeGoals) ?? 0 > Int(myRound.awayGoals) ?? 0 {
                                    myRound.result = "defeated"
                                } else {
                                    myRound.result = "lost to"
                                }
                            }
                        }
                    }
                }
            }
        }
        if lines[i].contains("/game/") {
            myRound.gameID = String(lines[i].split(separator: "/")[3])
            myRound.id = UUID()
            rounds.append(myRound)
            myRound = Round()
        }
    }
    return (rounds, byeTeams)
}
