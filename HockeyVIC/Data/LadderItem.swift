//
//  LadderItem.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
struct LadderItem: Hashable, Equatable, Identifiable {
    var id: UUID
    var pos: Int
    var teamName: String
    var compID: String
    var teamID: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var forfeits: Int
    var byes: Int
    var scoreFor: Int
    var scoreAgainst: Int
    var diff: Int
    var points: Int
    var winRatio: String
    
    init() {
        self.id = UUID()
        self.pos = 0
        self.teamName = ""
        self.compID = ""
        self.teamID = ""
        self.played = 0
        self.wins = 0
        self.draws = 0
        self.losses = 0
        self.forfeits = 0
        self.byes = 0
        self.scoreFor = 0
        self.scoreAgainst = 0
        self.diff = 0
        self.points = 0
        self.winRatio = ""
    }
}
