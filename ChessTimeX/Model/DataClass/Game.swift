//
//  Game.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

protocol GameProtocol {
    var rule: GameRule { get }
    var firstPlayerTimer: GameTimerProtocol { get }
    var secondPlayerTimer: GameTimerProtocol { get }
    
    func resetGame()
}



class Game: GameProtocol {
    let rule: GameRule
    
    let firstPlayerTimer: GameTimerProtocol
    let secondPlayerTimer: GameTimerProtocol
    
    init(gameRule: GameRule) {
        rule = gameRule
        firstPlayerTimer = GameTimer()
        secondPlayerTimer = GameTimer()
    }
    
}
