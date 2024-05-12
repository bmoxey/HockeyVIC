//
//  GetComps.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
func getComps(assoc: AssocData) async -> [Team] {
    var myCompName = ""
    var myCompID = ""
    var comps: [Team] = []
    var lines: [String] = []
    lines = GetUrl(url: "https://revolutionise.com.au/\(assoc.code)/games/")
    for i in 0 ..< lines.count {
        if lines[i].contains("reports/games/") {
            myCompName = lines[i-5]
            myCompID = GetLastBit(fullName: lines[i], char: "/")
        }
        if lines[i].contains("games/\(myCompID)/") {
            let myDivName = ShortDivName(fullName: String(lines[i+1]))
            let myDivID = GetLastBit(fullName: lines[i], char: "/")
            var type = "👫"
            if myDivName.contains("Boy") { type =  "👦🏻" }
            if myDivName.contains("Girl") { type = "👧🏻" }
            if myDivName.lowercased().contains("men") || assoc.name.contains("Men") || myDivName.range(of: "\\bM\\d", options: .regularExpression) != nil {
                type = "👨🏻"
                if myDivName.contains("+") || myDivName.contains("Over") || myDivName.contains("Master") || assoc.name.contains("Master") || myDivName.range(of: "O\\d{2}", options: .regularExpression) != nil {
                    type = "👴🏻"
                }
            }
            if myDivName.lowercased().contains("women") || myDivName.lowercased().contains("ladies") || myDivName.range(of: "\\bW\\d", options: .regularExpression) != nil {
                type = "👩🏻"
                if myDivName.contains("+") || myDivName.contains("Over") || myDivName.contains("Master") || assoc.name.contains("Master") || myDivName.range(of: "O\\d{2}", options: .regularExpression) != nil {
                    type = "👵🏻"
                }
            }
            comps.append(Team(assocName: assoc.name, assocCode: assoc.code, compName: myCompName, compID: myCompID, divName: myDivName, divID: myDivID, teamName: "", teamID: "", clubName: "", type: type, isCurrent: false))
        }
    }
    return comps
}
