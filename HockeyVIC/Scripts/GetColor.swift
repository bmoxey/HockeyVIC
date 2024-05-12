//
//  GetColor.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
import SwiftUI
func getColor(result: String) -> Color {
    var col: Color = Color("TextColor")
    if result == "Win" { col = Color.green }
    if result == "Loss" { col = Color.red }
    if result == "Draw" { col = Color.yellow }
    if result == "No Game" { col = Color(UIColor.lightGray) }
    if result == "No Results" { col = Color(UIColor.lightGray) }
    if result == "BYE" { col = Color.cyan }
    return col
}
