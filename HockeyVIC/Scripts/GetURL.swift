//
//  GetURL.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
func GetUrl(url: String) -> [String] {
    guard let myUrl = URL(string: url)
    else { return [] }
    do {
        guard let html = fetchData(from: myUrl)
        else { return [] }
        return html.splitOnGreaterThanOrLessThan()
    }
}

func fetchData(from url: URL) -> String? {
    var result: String?
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        defer { semaphore.signal() }
        if let error = error {
            print("Error: \(error)")
            return
        }
        if let data = data, let htmlString = String(data: data, encoding: .utf8) {
            result = htmlString
        }
    }.resume()
    semaphore.wait()
    return result
}

extension String {
    func splitOnGreaterThanOrLessThan() -> [String] {
        var parts: [String] = []
        var currentPart = ""
        var previousCharacter: Character?

        for character in self {
            if character == ">" || character == "<" {
                parts.append(currentPart)
                currentPart = ""
                if previousCharacter == character {
                    parts.append("")
                }
            } else {
                currentPart += String(character)
            }
            previousCharacter = character
        }
        parts.append(currentPart)
        return parts
    }
}
