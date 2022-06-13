//
//  GameProtocol.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

struct ClassicGame: GameProtocol, IncrementTypeProtocol {
    let rule: GameRule
    let disposables = Disposables()
    
    let isPlaying = CurrentValueSubject<Bool, Never>(false)
    let isFirstPlayersTurn = CurrentValueSubject<Bool, Never>(true)
    
    let firstPlayerTimer: GameTimerProtocol
    let firstPlayerMoves = CurrentValueSubject<Int, Never>(0)
    
    let secondPlayerTimer: GameTimerProtocol
    let secondPlayerMoves = CurrentValueSubject<Int, Never>(0)
    
    init(gameRule: GameRule) {
        rule = gameRule
        
        firstPlayerTimer = GameTimer(seconds: rule.firstPlayerSeconds)
        secondPlayerTimer = GameTimer(seconds: rule.secondPlayerSeconds)
    }
}
