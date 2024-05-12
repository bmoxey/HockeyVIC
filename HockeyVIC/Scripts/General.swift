//
//  General.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation

func countdownString(timeRemaining: Double) -> String {
    let days = Int(timeRemaining) / (60 * 60 * 24)
    let hours = Int(timeRemaining) % (60 * 60 * 24) / 3600
    let minutes = Int(timeRemaining) % 3600 / 60
    let seconds = Int(timeRemaining) % 60
    if days > 0 { return String(format: "Game starts in %d days, %d hours", days, hours) }
    if hours > 0 { return String(format: "Game starts in %d hours, %d minutes", hours, minutes)}
    return String(format: "Game starts in %d mins, %d secs", minutes, seconds)
}

func GetClubName(teamName: String) -> String {
    var clubName: String = currentAssoc.code
    for club in clubs {
        if club.assoc == currentAssoc.name || club.assoc == nil {
            if teamName.contains(club.clubName) {
                clubName = club.clubName
            }
            for other in club.otherNames ?? [] {
                if teamName.contains(other) {
                    clubName = club.clubName
                }
            }
        }
    }
    return clubName
}


func ShortTeamName(fullName: String) -> String {
    var newString = fullName.replacingOccurrences(of: " Hockey", with: "")
        .replacingOccurrences(of: " Club", with: "")
        .replacingOccurrences(of: " Association", with: "")
        .replacingOccurrences(of: " Sports INC", with: "")
        .replacingOccurrences(of: " Section", with: "")
        .replacingOccurrences(of: " United", with: " Utd")
        .replacingOccurrences(of: " University", with: " Uni")
        .replacingOccurrences(of: "Eastern Christian Organisation (ECHO)", with: "ECHO")
        .replacingOccurrences(of: "Melbourne High School Old Boys", with: "MHSOB")
        .replacingOccurrences(of: "Greater ", with: "")
    newString = removeDuplicateWords(from: newString)
    return newString
}

func removeDuplicateWords(from string: String) -> String {
    var uniqueWords = Set<String>()
    var result = ""
    let words = string.components(separatedBy: .whitespacesAndNewlines)
    for word in words {
        if !uniqueWords.contains(word) {
            uniqueWords.insert(word)
            result += word + " "
        }
    }
    result = result.trimmingCharacters(in: .whitespacesAndNewlines)
    return result
}

func getDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    return dateFormatter.string(from: date)
}

func getSymbol(result: String, roundNo: String, isCurrent: Bool) -> String {
    var text: String
    var bit: String
    text = "smallcircle.filled.circle.fill"
    if result == "No Game" && !isCurrent { bit = "" } else {bit = ".fill"}
    if roundNo.contains("Round ") {
        text = roundNo.replacingOccurrences(of: "Round ", with: "")
        text = "\(text).circle\(bit)"
    }
    if result == "BYE" { text = "hand.raised.circle.fill" }
    if roundNo.contains("Final") {text = "f.circle\(bit)"}
    if roundNo.contains("Semi Final") {text = "s.circle\(bit)"}
    if roundNo.contains("Quarter Final") {text = "q.circle\(bit)"}
    if roundNo.contains("Preliminary Final") {text = "p.circle\(bit)"}
    if roundNo.contains("Grand Final") {text = "trophy.circle\(bit)"}
    return text
}

func GetScores(scores: String, seperator: String) -> (String, String) {
    var homeScore = ""
    var awayScore = ""
    if scores.contains(seperator) {
        let myScores = scores.components(separatedBy: seperator)
        homeScore = myScores[0].trimmingCharacters(in: .whitespacesAndNewlines)
        awayScore = myScores[1].trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return (homeScore, awayScore)
}

func FixName(fullname: String) -> (String, String, Bool) {
    var myCap = false
    var myName = fullname
    if myName.contains(" (Captain)") {
        myCap = true
        myName = myName.replacingOccurrences(of: " (Captain)", with: "")
    }
    let mybits = myName.split(separator: ",")
    var surname = ""
    if mybits.count > 0 {
        surname = mybits[0].trimmingCharacters(in: .whitespaces).capitalized
        if surname.contains("'") {
            let mybits1 = surname.split(separator: "'")
            surname = mybits1[0].capitalized + "'" + mybits1[1].capitalized
        }
        let name = surname
        let surname = name.count >= 3 && name.lowercased().hasPrefix("mc") ? String(name.prefix(2)) + name[name.index(name.startIndex, offsetBy: 2)].uppercased() + String(name.suffix(from: name.index(after: name.index(name.startIndex, offsetBy: 2)))) : name
        if mybits.count > 1 {
            myName = mybits[1].trimmingCharacters(in: .whitespaces).capitalized + " " + surname
        }
    }
    return(myName, surname, myCap)
}

func ShortDivName(fullName: String) -> String {
    var newString = fullName.replacingOccurrences(of: "GAME Clothing ", with: "")
    if let firstFourDigits = Int(newString.prefix(4)), firstFourDigits > 1000 { newString.removeFirst(4) }
    if let lastFourDigits = Int(newString.suffix(4)), lastFourDigits > 1000 { newString.removeLast(4) }
    newString = newString.trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: .punctuationCharacters)
        .trimmingCharacters(in: .whitespaces)
    return newString
}

func GetBit(fullName: String, part: Int, char: String) -> String {
    var string = ""
    let split = fullName.split(separator: char)
    if split.count > part {
        string = String(split[part]).trimmingCharacters(in: .punctuationCharacters)
    }
    return string
}

func GetLastBit(fullName: String, char: String) -> String {
    var string = ""
    let split = fullName.split(separator: char)
    if split.count > 0 {
        string = String(split[split.count - 1]).trimmingCharacters(in: .punctuationCharacters)
    }
    return string
}
