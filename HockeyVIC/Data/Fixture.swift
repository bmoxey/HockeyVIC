//
//  Fixture.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import Foundation

struct Fixture: Codable, Identifiable, Hashable {
    var id: UUID
    var assocCode: String
    var roundNo: String
    var date: Date
    var field: String
    var venue: String
    var myTeam: String
    var opponent: String
    var result: String
    var status: String
    var gameID: String
    
    init() {
        self.id = UUID()
        self.assocCode = ""
        self.roundNo = ""
        self.date = Date()
        self.field = ""
        self.venue = ""
        self.myTeam = ""
        self.opponent = ""
        self.result = ""
        self.status = ""
        self.gameID = ""
    }
}
