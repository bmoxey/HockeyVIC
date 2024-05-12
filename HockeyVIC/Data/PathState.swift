//
//  PathState.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
class PathState: ObservableObject {
    enum Destination: String, Hashable {
        case getAssocs,getComps,getClubs
    }
    @Published var path: [Destination] = []
}
