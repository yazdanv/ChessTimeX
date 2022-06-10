//
//  Game.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

protocol GameProtocol {
    var rule: GameRule { get set }
    var disposables: Set<AnyCancellable> { get set }
    var isPlaying: CurrentValueSubject<Bool, Never> { get set }
    var firstPlayersTurn: CurrentValueSubject<Bool, Never> { get set }
    var firstPlayerTimer: GameTimerProtocol { get }
    var secondPlayerTimer: GameTimerProtocol { get }
    
    func resetWith(rule: GameRule)
    func setupObservers()
    
    func changingFromFirstToSecond()
    func changingFromSecondToFirst()
}

extension GameProtocol {
    
    var firstPlayerSeconds: CurrentValueSubject<Int, Never> {
        return firstPlayerTimer.timeSeconds
    }
    
    var secondPlayerSeconds: CurrentValueSubject<Int, Never> {
        return secondPlayerTimer.timeSeconds
    }
    
    func changePlayState(_ playState: Bool) {
        let timer = self.firstPlayersTurn.value ? self.firstPlayerTimer:self.secondPlayerTimer
        timer.isRunning.send(playState)
    }

    
    func reset() {
        isPlaying.send(false)
        firstPlayersTurn.send(true)
        firstPlayerTimer.resetTimer(seconds: rule.timeSecondsFirstPlayer)
        secondPlayerTimer.resetTimer(seconds: rule.timeSecondsSecondPlayer)
    }
    
    func play() {
        if (!isPlaying.value) {
            isPlaying.send(true)
        }
    }
    
    func pause() {
        if (isPlaying.value) {
            isPlaying.send(false)
        }
    }
    
    func changeToFirstPlayer() {
        if !firstPlayerTimer.isRunning.value {
            secondPlayerTimer.isRunning.send(false)
            changingFromSecondToFirst()
            firstPlayerTimer.isRunning.send(true)
        }
    }
    
    func changeToSecondPlayer() {
        if !secondPlayerTimer.isRunning.value {
            firstPlayerTimer.isRunning.send(false)
            changingFromFirstToSecond()
            secondPlayerTimer.isRunning.send(true)
        }
    }
    
}


class ClassicGame: GameProtocol {

    var rule: GameRule
    var disposables = Set<AnyCancellable>()
    var isPlaying = CurrentValueSubject<Bool, Never>(false)
    var firstPlayersTurn = CurrentValueSubject<Bool, Never>(true)
    
    let firstPlayerTimer: GameTimerProtocol
    let secondPlayerTimer: GameTimerProtocol
    
    init(gameRule: GameRule) {
        rule = gameRule
        firstPlayerTimer = GameTimer()
        secondPlayerTimer = GameTimer()
        setupObservers()
    }
    
    func resetWith(rule: GameRule) {
        self.rule = rule
        self.reset()
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
                    self?.firstPlayersTurn.send(true)
                }
            }.store(in: &disposables)
        secondPlayerTimer.isRunning
            .receive(on: DispatchQueue.global())
            .sink { [weak self] value in
                if (value) {
                    self?.firstPlayersTurn.send(false)
                }
            }.store(in: &disposables)
    }
    
    private func addTimeIfNeeded(_ stoppingTimer: GameTimerProtocol) {
        var increment = 0
        switch rule.incrementType {
        case .none:
            break
        case .fisher:
            increment = rule.incrementSeconds
        }
        if increment > 0 {
            stoppingTimer.incrementTime(seconds: increment)
        }
    }
    
    func changingFromFirstToSecond() {
        addTimeIfNeeded(self.firstPlayerTimer)
    }
    
    func changingFromSecondToFirst() {
        addTimeIfNeeded(self.secondPlayerTimer)
    }
    
}
