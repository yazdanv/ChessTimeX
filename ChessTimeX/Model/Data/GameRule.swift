//
//  GameRule.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation

struct GameRule: Hashable {
    let name: String
    
    let gameType: GameType
    let firstPlayerSeconds: Int
    let secondPlayerSeconds: Int
    
    let incrementType: IncrementType
    let incrementSeconds: Int
    
    var customIcon: String?
}

extension GameRule {
    var timeTitle: String {
        return firstPlayerSeconds == secondPlayerSeconds ?
            firstPlayerSeconds.formattedTimeString:
            "\(firstPlayerSeconds.formattedTimeString) vs \(secondPlayerSeconds.formattedTimeString)"
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
            return GameRuleAssets.classic
        case .hourglass:
            return GameRuleAssets.hourglass
        }
    }
}
