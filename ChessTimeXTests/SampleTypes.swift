//
//  SampleStructs.swift
//  ChessTimeXTests
//
//  Created by Yazdan on 6/12/22.
//

import Foundation
import Combine
@testable import ChessTimeX

struct SampleGameWithoutIncrement: GameProtocol {
    
    let rule: GameRule
    let disposables = Disposables()
    
    let isPlaying = CurrentValueSubject<Bool, Never>(false)
    let isFirstPlayersTurn = CurrentValueSubject<Bool, Never>(true)
    
    let firstPlayerTimer: GameTimerProtocol
    let secondPlayerTimer: GameTimerProtocol
    
    init(gameRule: GameRule) {
        rule = gameRule
        
        firstPlayerTimer = GameTimer(seconds: rule.firstPlayerSeconds)
        secondPlayerTimer = GameTimer(seconds: rule.secondPlayerSeconds)
    }
}
