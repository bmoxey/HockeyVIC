//
//  Player.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import Foundation
struct Player: Codable, Identifiable, Equatable, Hashable {
    var id: UUID
    var team: String
    var name: String
    var numberGames: Int
    var goals: Int
    var greenCards: Int
    var yellowCards: Int
    var redCards: Int
    var goalie: Int
    var surname: String
    var captain: Bool
    var fillin: Bool
    var date: String
    var statsLink: String
    
    init() {
        self.id = UUID()
        self.team = ""
        self.name = ""
        self.numberGames = 0
        self.goals = 0
        self.greenCards = 0
        self.yellowCards = 0
        self.redCards = 0
        self.goalie = 0
        self.surname = ""
        self.captain = false
        self.fillin = false
        self.date = ""
        self.statsLink = ""
    }
}
