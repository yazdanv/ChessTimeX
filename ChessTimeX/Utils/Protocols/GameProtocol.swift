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
    var disposables: Set<AnyCancellable> { get set }
    var isPlaying: CurrentValueSubject<Bool, Never> { get }
    var isFirstPlayersTurn: CurrentValueSubject<Bool, Never> { get }
    var firstPlayerTimer: GameTimerProtocol { get }
    var secondPlayerTimer: GameTimerProtocol { get }
    
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
    
    func changePlayState(_ playState: Bool) {
        let timer = self.isFirstPlayersTurn.value ? self.firstPlayerTimer:self.secondPlayerTimer
        timer.changeRunState(playState)
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
        }
    }
    
    func pause() {
        if (isPlaying.value) {
            isPlaying.send(false)
        }
    }
    
    func changeToFirstPlayer() {
        if !firstPlayerTimer.isRunning.value && secondPlayerSeconds.value > 0 {
            secondPlayerTimer.changeRunState(false)
            changingFromSecondToFirst()
            firstPlayerTimer.changeRunState(true)
        }
    }
    
    func changeToSecondPlayer() {
        if !secondPlayerTimer.isRunning.value && firstPlayerSeconds.value > 0 {
            firstPlayerTimer.changeRunState(false)
            changingFromFirstToSecond()
            secondPlayerTimer.changeRunState(true)
        }
    }
    
}
