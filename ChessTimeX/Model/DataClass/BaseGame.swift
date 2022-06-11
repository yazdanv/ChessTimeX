//
//  BaseGame.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

// The used instance of game inside GameViewModel is based on GameProtocol which exposes all outside facing
//  functionality so each game method could implement it's own custom functionality but the BaseGame provides
//  a simple starter base for the basic game types (classic and hourglass)
class BaseGame: GameProtocol {
    
    let rule: GameRule
    
    var disposables = Set<AnyCancellable>()
    
    let isPlaying = CurrentValueSubject<Bool, Never>(false)
    let isFirstPlayersTurn = CurrentValueSubject<Bool, Never>(true)
    
    let firstPlayerTimer: GameTimerProtocol
    let secondPlayerTimer: GameTimerProtocol
    
    init(gameRule: GameRule) {
        rule = gameRule
        
        firstPlayerTimer = GameTimer(seconds: rule.timeSecondsFirstPlayer)
        secondPlayerTimer = GameTimer(seconds: rule.timeSecondsSecondPlayer)
        
        setupObservers()
    }
    
    func setupObservers() {
        isPlaying
            .receive(on: DispatchQueue.global())
            .sink {[weak self] playState in
                self?.changePlayState(playState)
            }.store(in: &disposables)
        firstPlayerTimer.isRunning
            .receive(on: DispatchQueue.global())
            .sink { [weak self] value in
                if (value) {
                    self?.isFirstPlayersTurn.send(true)
                }
            }.store(in: &disposables)
        secondPlayerTimer.isRunning
            .receive(on: DispatchQueue.global())
            .sink { [weak self] value in
                if (value) {
                    self?.isFirstPlayersTurn.send(false)
                }
            }.store(in: &disposables)
    }
    
    func changingFromFirstToSecond() {}
    
    func changingFromSecondToFirst() {}
}
