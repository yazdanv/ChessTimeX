//
//  GameRule.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation

struct GameRule {
    let name: String
    
    let gameType: GameType
    let timeSecondsFirstPlayer: Int
    let timeSecondsSecondPlayer: Int
    
    let incrementType: IncrementType
    let incrementSeconds: Int
    
    var customIcon: String?
}

extension GameRule {
    var timeTitle: String {
        return timeSecondsFirstPlayer == timeSecondsSecondPlayer ?
            timeSecondsFirstPlayer.formattedTimeString:
            "\(timeSecondsFirstPlayer.formattedTimeString) vs \(timeSecondsSecondPlayer.formattedTimeString)"
    }
    
    var incrementTitle: String {
        return (incrementSeconds > 0 && incrementType != .none) ? "\(incrementType.rawValue) \(incrementSeconds)s":IncrementType.none.rawValue
    }
    
    var nameTitle: String {
        return name != "" ? name:gameType.rawValue
    }
    
    var title: String {
        return "\(nameTitle) | \(timeTitle) | \(incrementTitle)"
    }
    
    var iconImage: String {
        if let customIcon = self.customIcon {
            return customIcon
        }
        switch gameType {
        case .classic:
            return "baseball.diamond.bases"
        case .hourglass:
            return "hourglass.circle.fill"
        }
    }
}
