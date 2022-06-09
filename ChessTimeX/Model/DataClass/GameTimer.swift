//
//  GameTimer.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

protocol GameTimerProtocol {
    var timeSeconds: CurrentValueSubject<Int, Never> { get set }
    var isRunning: CurrentValueSubject<Bool, Never> { get set }
    
    func resetTimer(seconds: Int)
    func incrementTime(seconds: Int)
}

class GameTimer: GameTimerProtocol {
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    var timerSubscription: AnyCancellable?
    var subscriptions = Set<AnyCancellable>()
    
    var isRunning = CurrentValueSubject<Bool, Never>(false)
    var timeSeconds = CurrentValueSubject<Int, Never>(0)
    
    init() {
        isRunning.sink(receiveValue: {[weak self] _isRunning in
            if (_isRunning) {
                self?.attachTimer()
            } else {
                self?.detachTimer()
            }
        }).store(in: &subscriptions)
    }
    
    func attachTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerSubscription = timer?.sink {[weak self] _ in
            let timeSecondsUnwrapped = self?.timeSeconds.value ?? 0
            if (timeSecondsUnwrapped > 0) {
                self?.timeSeconds.send(timeSecondsUnwrapped - 1)
            } else {
                self?.detachTimer()
            }
        }
    }
    
    func detachTimer() {
        timerSubscription?.cancel()
        timer?.upstream.connect().cancel()
    }

    func resetTimer(seconds: Int) {
        isRunning.send(false)
        timeSeconds.send(seconds)
    }
    
    func incrementTime(seconds: Int) {
        let timeSecondsValue = timeSeconds.value
        timeSeconds.send(timeSecondsValue + seconds)
    }
    
}
