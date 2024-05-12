//
//  GetPlayer.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
func getPlayer(player: Player, team: Team) async -> [Player] {
    var myPlayer = Player()
    var players = [Player]()
    var lines: [String] = []
    var attended: Bool = false
    var fillin: Bool = false
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = " E dd MMM yyyy HH:mm "
    let quickFormatter = DateFormatter()
    quickFormatter.dateFormat = "dd MMM HH:mm"
    lines = GetUrl(url: player.statsLink)
    for i in 0 ..< lines.count - 2 {
        if let dateTime = dateFormatter.date(from: lines[i]) {
            myPlayer.date = quickFormatter.string(from: dateTime)
        }
        if lines[i].contains("Attended") { attended = true }
        if lines[i].contains("Filled in") { fillin = true }
        if lines[i].contains("/games/") {
            if lines[i].contains("/games/team/") {
                if lines[i].contains(team.teamID) {
                    myPlayer.goals = Int(lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    myPlayer.greenCards = Int(lines[i+11].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    myPlayer.yellowCards = Int(lines[i+15].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    myPlayer.redCards = Int(lines[i+19].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    myPlayer.goalie = Int(lines[i+23].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                    if attended || fillin {
                        myPlayer.fillin = fillin
                        players.append(myPlayer)
                        myPlayer = Player()
                        attended = false
                        fillin = false
                    }
                } else {
                    attended = false
                    fillin = false
                }
            } else {
                if lines[i].contains("/round/") {
                    myPlayer.name = lines[i+1]
                }
            }
        }
    }
    return players
}
