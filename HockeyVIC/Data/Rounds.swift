//
//  Rounds.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
struct Rounds: Codable, Identifiable, Hashable {
    var id: UUID
    var roundNo: String
    var roundNum: String
    var textdate: String
    var lastdate: Date
    var result: String
    var played: String
    var divName: String
    
    init() {
        self.id = UUID()
        self.roundNo = ""
        self.roundNum = ""
        self.textdate = ""
        self.lastdate = Date()
        self.result = ""
        self.played = ""
        self.divName = ""
    }
}
