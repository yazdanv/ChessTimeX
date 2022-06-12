//
//  Game.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine


// Any class that conforms to GameProtocol could implement it's own logic but should follow some basic priciples
//  isPlaying: should always represent true when one of players timers is running and false when both are paused
//  isFirstPlayersTurn: should return true if it's first player's turn and false if it is second player's turn
//      this state is regardless of isPlaying state and always should follow the said guideline
protocol GameProtocol {
    var rule: GameRule { get }
    var disposables: Disposables { get }
    var isPlaying: CurrentValueSubject<Bool, Never> { get }
    var isFirstPlayersTurn: CurrentValueSubject<Bool, Never> { get }
    var firstPlayerTimer: GameTimerProtocol { get }
    var secondPlayerTimer: GameTimerProtocol { get }
}

extension GameProtocol {
    
    var firstPlayerSeconds: CurrentValueSubject<Int, Never> {
        return firstPlayerTimer.timeSeconds
    }
    
    var secondPlayerSeconds: CurrentValueSubject<Int, Never> {
        return secondPlayerTimer.timeSeconds
    }
    
    var firstTimerActive: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPlaying, isFirstPlayersTurn)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }
    
    var secondTimerActive: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPlaying, isFirstPlayersTurn)
            .map { $0.0 && !$0.1 }
            .eraseToAnyPublisher()
    }
    
    func reset() {
        isPlaying.send(false)
        isFirstPlayersTurn.send(true)
        firstPlayerTimer.resetTimer(seconds: rule.firstPlayerSeconds)
        secondPlayerTimer.resetTimer(seconds: rule.secondPlayerSeconds)
    }
    
    func play() {
        if (!isPlaying.value) {
            isPlaying.send(true)
            self.changePlayState(true)
        }
    }
    
    func pause() {
        if (isPlaying.value) {
            isPlaying.send(false)
            self.changePlayState(false)
        }
    }
    
    func changeToFirstPlayer() {
        if !firstPlayerTimer.isRunning.value && secondPlayerSeconds.value > 0 {
            secondPlayerTimer.stopTimer()
            changingFromSecondToFirst()
            firstPlayerTimer.startTimer()
            self.isFirstPlayersTurn.send(true)
        }
    }
    
    func changeToSecondPlayer() {
        if !secondPlayerTimer.isRunning.value && firstPlayerSeconds.value > 0 {
            firstPlayerTimer.stopTimer()
            changingFromFirstToSecond()
            secondPlayerTimer.startTimer()
            self.isFirstPlayersTurn.send(false)
        }
    }
    
    // Private Code
    
    private func changePlayState(_ playState: Bool) {
        let timer = self.isFirstPlayersTurn.value ? self.firstPlayerTimer:self.secondPlayerTimer
        (playState ? timer.startTimer:timer.stopTimer)()
    }
    
    private func changingFromFirstToSecond() {}
    
    private func changingFromSecondToFirst() {}
    
}
