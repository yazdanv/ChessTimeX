//
//  Game.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine


// Any struct that conforms to GameProtocol could implement it's own logic but should follow some basic priciples
//  isPlaying: should always represent true when one of players timers is running and false when both are paused
//  isFirstPlayersTurn: should return true if it's first player's turn and false if it is second player's turn
//      this state is regardless of isPlaying state and always should follow the said guideline
//  so it is best if different gametype structs don't touch these values but if they do follow the said rules
protocol GameProtocol {
    var rule: GameRule { get }
    var disposables: Disposables { get }
    
    var isPlaying: CurrentValueSubject<Bool, Never> { get }
    var isFirstPlayersTurn: CurrentValueSubject<Bool, Never> { get }
    
    var firstPlayerTimer: GameTimerProtocol { get }
    var firstPlayerMoves: CurrentValueSubject<Int, Never> { get }
    
    var secondPlayerTimer: GameTimerProtocol { get }
    var secondPlayerMoves: CurrentValueSubject<Int, Never> { get }
    
    func changingFromFirstToSecond()
    func changingFromSecondToFirst()
}

extension GameProtocol {
    
    // MARK: First player states and values
    var firstPlayerSeconds: CurrentValueSubject<Int, Never> {
        return firstPlayerTimer.timeSeconds
    }
    
    var firstPlayerNoOfMoves: CurrentValueSubject<Int, Never> {
        return firstPlayerMoves
    }
    
    var firstTimerActive: AnyPublisher<Bool, Never> {
        // Combining two value subjects into a single publisher so if
        //   any of them changes there would be value published to the
        //   firstTimerActive publisher
        Publishers.CombineLatest(isPlaying, isFirstPlayersTurn)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }
    
    // MARK: Second player states and values
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
    
    // MARK: Public facing functionality
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
            // Stop second player's timer and start the first player's
            // Also invoke changingFromSecondToFirst method so game types
            //   could implement custom functionality on user state change
            secondPlayerTimer.stopTimer()
            changingFromSecondToFirst()
            firstPlayerTimer.startTimer()
            // Send the updated value to isFirstPlayersTurn to update isActive states
            self.isFirstPlayersTurn.send(true)
            // Increment previously active player's moves
            self.secondPlayerMoves.send(self.secondPlayerMoves.value + 1)
        }
    }
    
    // This does exacly what changeToFirstPlayer does but the roles are reversed
    //   so for any further help read the comments from changeToFirstPlayer
    func changeToSecondPlayer() {
        if !secondPlayerTimer.isRunning.value && firstPlayerTimer.timeSeconds.value > 0 {
            firstPlayerTimer.stopTimer()
            changingFromFirstToSecond()
            secondPlayerTimer.startTimer()
            self.isFirstPlayersTurn.send(false)
            self.firstPlayerMoves.send(self.firstPlayerMoves.value + 1)
        }
    }
    
    // MARK: Used for internal use of GameProtocol based structs
    func changingFromFirstToSecond() {}
    
    func changingFromSecondToFirst() {}
    
    
    // MARK: Private Code
    private func changePlayState(_ playState: Bool) {
        let timer = self.isFirstPlayersTurn.value ? self.firstPlayerTimer:self.secondPlayerTimer
        (playState ? timer.startTimer:timer.stopTimer)()
    }
    
}
