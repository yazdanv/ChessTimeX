//
//  TimerViewModel.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/11/22.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    
    @Published var playerShowTime = "00:05:00"
    @Published var isTimerActive = false
    @Published var numberOfMoves = 0
    
    func updateActiveState(_ state: Bool) {
        isTimerActive = state
    }
    
    func setShowTime(_ timeSeconds: Int) {
        playerShowTime = timeSeconds > 0 ? timeSeconds.timerString:"Finished"
    }
    
    func setNumberOfMoves(_ number: Int) {
        numberOfMoves = number
    }
}
