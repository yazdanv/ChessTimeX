//
//  DefaultGameRule.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation

//TODO: Move game rules to a database so users could add permenant custom rules
struct DefaultGameRule {
    static var defaultRules: [GameRule] = [
        defaultRule,
        GameRule(name: "Rapid",
                gameType: GameType.classic,
                timeSecondsFirstPlayer: 10 * 60,
                timeSecondsSecondPlayer: 10 * 60,
                incrementType: IncrementType.fisher,
                incrementSeconds: 10
       ),
        GameRule(name: "Rapid",
                gameType: GameType.classic,
                timeSecondsFirstPlayer: 30 * 60,
                timeSecondsSecondPlayer: 30 * 60,
                incrementType: IncrementType.none,
                incrementSeconds: 0
       ),
        GameRule(name: "",
                gameType: GameType.hourglass,
                timeSecondsFirstPlayer: 5 * 60,
                timeSecondsSecondPlayer: 5 * 60,
                incrementType: IncrementType.none,
                incrementSeconds: 0
       )
    ]
    
    static var defaultRule: GameRule = GameRule(name: "Blitz",
                                                gameType: GameType.classic,
                                                timeSecondsFirstPlayer: 5 * 60,
                                                timeSecondsSecondPlayer: 5 * 60,
                                                incrementType: IncrementType.none,
                                                incrementSeconds: 0
                                       )
}
