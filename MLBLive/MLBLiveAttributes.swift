//
//  MLBLiveAttributes.swift
//  MLBLive
//
//  Created by 허원철(Woncheol Heo) on 9/3/24.
//

import SwiftUI
import ActivityKit

struct MLBLiveAttributes: ActivityAttributes, Identifiable {    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var awayTeam: String
        var homeTeam: String
        var awayScore: Int
        var homeScore: Int
        var pitcher: String
        var hitter: String
        var era: String
        var battingAverage: String
        var live: String
        var imageName: String
    }

    // Fixed non-changing properties about your activity go here!
    var ballpark: String
    var id = UUID()
}
