//
//  GameRule.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation

struct GameRule {
    let title: String
    
    let gameType: GameType
    let timeSecondsFirstPlayer: Int
    let timeSecondsSecondPlayer: Int
    
    let incrementType: IncrementType
    let incrementSeconds: Int
}
