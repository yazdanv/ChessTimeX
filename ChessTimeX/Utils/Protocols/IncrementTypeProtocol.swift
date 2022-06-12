//
//  IncrementTypeProtocol.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation

protocol IncrementTypeProtocol {}

extension IncrementTypeProtocol where Self: GameProtocol {
    
    func addTimeIfNeeded(_ stoppingTimer: GameTimerProtocol) {
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
