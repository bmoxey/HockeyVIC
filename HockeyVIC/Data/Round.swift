//
//  Round.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import Foundation
struct Round: Codable, Identifiable, Hashable {
    var id: UUID
    var roundNo: String
    var date: Date
    var field: String
    var venue: String
    var address: String
    var myTeam: String
    var opponent: String
    var homeTeam: String
    var awayTeam: String
    var homeGoals: String
    var awayGoals: String
    var result: String
    var played: String
    var gameID: String
    var divName: String
    
    init() {
        self.id = UUID()
        self.roundNo = ""
        self.date = Date()
        self.field = ""
        self.venue = ""
        self.address = ""
        self.myTeam = ""
        self.opponent = ""
        self.homeTeam = ""
        self.awayTeam = ""
        self.homeGoals = ""
        self.awayGoals = ""
        self.result = ""
        self.played = ""
        self.gameID = ""
        self.divName = ""
    }
}
