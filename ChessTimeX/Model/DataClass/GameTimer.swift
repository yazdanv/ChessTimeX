//
//  GameTimer.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

class GameTimer: GameTimerProtocol {
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    private var timerSubscription: AnyCancellable?
    private var disposables = Set<AnyCancellable>()
    
    let isRunning = CurrentValueSubject<Bool, Never>(false)
    let timeSeconds: CurrentValueSubject<Int, Never>
    
    init(seconds: Int = 0) {
        timeSeconds = CurrentValueSubject<Int, Never>(seconds)
        isRunning.sink(receiveValue: {[weak self] isRunning in
            if (isRunning) {
                self?.attachTimer()
            } else {
                self?.detachTimer()
            }
        }).store(in: &disposables)
    }
    
    private func attachTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerSubscription = timer?.sink {[weak self] _ in
            guard let self = self else {return}
            if (self.timeSeconds.value > 0) {
                self.timeSeconds.send(self.timeSeconds.value - 1)
            } else {
                self.detachTimer()
            }
        }
    }
    
    private func detachTimer() {
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
    
    func changeRunState(_ isRunning: Bool) {
        self.isRunning.send(isRunning)
    }
}
