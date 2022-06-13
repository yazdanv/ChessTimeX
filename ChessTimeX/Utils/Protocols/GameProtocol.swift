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
    var firstPlayerMoves: CurrentValueSubject<Int, Never> { get }
    
    var secondPlayerTimer: GameTimerProtocol { get }
    var secondPlayerMoves: CurrentValueSubject<Int, Never> { get }
}

extension GameProtocol {
    
    var firstPlayerSeconds: CurrentValueSubject<Int, Never> {
        return firstPlayerTimer.timeSeconds
    }
    
    var firstPlayerNoOfMoves: CurrentValueSubject<Int, Never> {
        return firstPlayerMoves
    }
    
    var firstTimerActive: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPlaying, isFirstPlayersTurn)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }
    
    
    var secondPlayerSeconds: CurrentValueSubject<Int, Never> {
        return secondPlayerTimer.timeSeconds
    }
    
    var secondPlayerNoOfMoves: CurrentValueSubject<Int, Never> {
        return secondPlayerMoves
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
        firstPlayerMoves.send(0)
        
        secondPlayerTimer.resetTimer(seconds: rule.secondPlayerSeconds)
        secondPlayerMoves.send(0)
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
        if !firstPlayerTimer.isRunning.value && secondPlayerTimer.timeSeconds.value > 0 {
            secondPlayerTimer.stopTimer()
            changingFromSecondToFirst()
            firstPlayerTimer.startTimer()
            self.isFirstPlayersTurn.send(true)
            self.secondPlayerMoves.send(self.secondPlayerMoves.value + 1)
        }
    }
    
    func changeToSecondPlayer() {
        if !secondPlayerTimer.isRunning.value && firstPlayerTimer.timeSeconds.value > 0 {
            firstPlayerTimer.stopTimer()
            changingFromFirstToSecond()
            secondPlayerTimer.startTimer()
            self.isFirstPlayersTurn.send(false)
            self.firstPlayerMoves.send(self.firstPlayerMoves.value + 1)
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
