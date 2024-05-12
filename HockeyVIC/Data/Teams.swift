//
//  Teams.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
import SwiftData

@Model
class Team: Identifiable, ObservableObject, CustomStringConvertible {
    var orderIndex: Int?
    var assocName: String
    var assocCode: String
    var compName: String
    var compID: String
    var divName: String
    var divID: String
    var teamName: String
    var teamID: String
    var clubName: String
    var type: String
    var isCurrent: Bool
    
    init(assocName: String = "", assocCode: String = "", compName: String = "", compID: String = "", divName: String = "", divID: String = "", teamName: String = "", teamID: String = "", clubName: String = "", type: String = "", isCurrent: Bool = false, backingData: Void? = nil) {
        self.orderIndex = nil
        self.assocName = assocName
        self.assocCode = assocCode
        self.compName = compName
        self.compID = compID
        self.divName = divName
        self.divID = divID
        self.teamName = teamName
        self.teamID = teamID
        self.clubName = clubName
        self.type = type
        self.isCurrent = isCurrent
    }
    var description: String {
        return """
        Order Index: \(orderIndex ?? -1)
        Assoc Name: \(assocName)
        Assoc Code: \(assocCode)
        Comp Name: \(compName)
        Comp ID: \(compID)
        Div Name: \(divName)
        Div ID: \(divID)
        Team Name: \(teamName)
        Team ID: \(teamID)
        Club Name: \(clubName)
        Type: \(type)
        Is Current: \(isCurrent)
        """
    }
}
