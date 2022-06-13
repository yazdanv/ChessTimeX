//
//  GameTimer.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

struct GameTimer: GameTimerProtocol {
    
    private var timer: Timer.TimerPublisher?
    private var disposables = Disposables()
    
    let isRunning = CurrentValueSubject<Bool, Never>(false)
    let timeSeconds: CurrentValueSubject<Int, Never>
    
    init(seconds: Int = 0) {
        timeSeconds = CurrentValueSubject<Int, Never>(seconds)
        timer = Timer.publish(every: 1, on: .main, in: .common)
    }
    
    // MARK: internal private functionality
    private func attachTimer() {
        timer?.autoconnect().sink {_ in
            if (self.timeSeconds.value > 0) {
                self.timeSeconds.send(self.timeSeconds.value - 1)
            } else {
                self.detachTimer()
            }
        }.store(in: &disposables.items)
    }
    
    private func detachTimer() {
        disposables.cancelAll()
        timer?.connect().cancel()
    }
    
    // MARK: Public facing functionality
    func incrementTime(seconds: Int) {
        let timeSecondsValue = timeSeconds.value
        timeSeconds.send(timeSecondsValue + seconds)
    }
    
    func startTimer() {
        if (!isRunning.value) {
            attachTimer()
            isRunning.send(true)
        }
    }
    
    
    func stopTimer() {
        if (isRunning.value) {
            detachTimer()
            isRunning.send(false)
        }
    }
    
    func resetTimer(seconds: Int) {
        stopTimer()
        timeSeconds.send(seconds)
    }
}
