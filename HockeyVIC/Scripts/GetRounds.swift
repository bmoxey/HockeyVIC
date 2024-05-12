//
//  GetRounds.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import Foundation
func getRounds(team: Team) async -> [Rounds] {
    var rounds: [Rounds] = []
    var myRound: Rounds = Rounds()
    var lines: [String] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = " E dd MMM yyyy HH:mm "
    lines = GetUrl(url: "https://revolutionise.com.au/\(team.assocCode)/games/\(team.compID)/\(team.divID)")
    for i in 0 ..< lines.count - 2 {
        if lines[i].contains("/games/") {
            if lines[i].contains("/round/") {
                myRound.roundNo = lines[i+3].trimmingCharacters(in: .whitespacesAndNewlines)
                myRound.roundNum = GetLastBit(fullName: lines[i], char: "/").trimmingCharacters(in: .punctuationCharacters)
//                myRound.roundNum = String(lines[i].split(separator: "/")[6]).trimmingCharacters(in: .punctuationCharacters)
                myRound.played = myRound.roundNum
                if myRound.played.contains(",") {
                    myRound.played = String(myRound.played.split(separator: "/")[-1])
                }
                myRound.textdate = lines[i+13].trimmingCharacters(in: .whitespacesAndNewlines)
                myRound.lastdate = GetLastDate(textdate: myRound.textdate)
                if myRound.lastdate > Date() {
                    myRound.result = "No Game"
                }
                myRound.id = UUID()
                rounds.append(myRound)
                myRound = Rounds()
            }
        }
    }

    return rounds
}

func GetLastDate(textdate: String) -> Date {
    var lastdate: Date = Date()
    var text: String = ""
    
    let calendar = Calendar.current
    let year = calendar.component(.year, from: Date())
    
    text = textdate
    if textdate.contains(",") {
        let components = textdate.components(separatedBy: ",")
        text = components.last!
    }
    text = text + " " + String(year)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "E dd MMM yyyy"
    
    if let date = formatter.date(from: text) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        lastdate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? Date()
    }
    
    return lastdate
}
