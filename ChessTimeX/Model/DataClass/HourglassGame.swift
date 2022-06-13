//
//  HourGlassGame.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine


struct HourglassGame: GameProtocol, IncrementProtocol {
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
        
        setObservers()
    }
    
    private func setObservers() {
        // Adding one second to the other player when the player uses one second
        self.firstPlayerSeconds
            .receive(on: DispatchQueue.global())
            .sink { _ in
                if (self.isFirstPlayersTurn.value && self.isPlaying.value) {
                    self.secondPlayerTimer.incrementTime(seconds: 1)
                }
            }.store(in: &disposables.items)
        self.secondPlayerSeconds
            .receive(on: DispatchQueue.global())
            .sink { _ in
                if (!self.isFirstPlayersTurn.value && self.isPlaying.value) {
                    self.firstPlayerTimer.incrementTime(seconds: 1)
                }
            }.store(in: &disposables.items)
    }
}
