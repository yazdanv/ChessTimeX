//
//  DefaultGameRule.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation

struct DefaultGameRule {
    static var defaultRules: [GameRule] = [
        defaultRule
    ]
    
    static var defaultRule: GameRule = GameRule(title: "Blitz | No Increment",
                                                gameType: GameType.classic,
                                                timeSecondsFirstPlayer: 5 * 60,
                                                timeSecondsSecondPlayer: 5 * 6,
                                                incrementType: IncrementType.none,
                                                incrementSeconds: 0
                                       )
}
