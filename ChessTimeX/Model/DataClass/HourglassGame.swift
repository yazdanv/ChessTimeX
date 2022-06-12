//
//  HourGlassGame.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine


struct HourglassGame: GameProtocol, IncrementTypeProtocol {
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
        
        setObservers()
    }
    
    private func setObservers() {
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
