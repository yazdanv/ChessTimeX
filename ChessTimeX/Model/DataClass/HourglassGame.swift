//
//  HourGlassGame.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

class HourglassGame: BaseGame, IncrementTypeProtocol {
    
    override func setupObservers() {
        super.setupObservers()
        self.firstPlayerSeconds
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else {return}
                if (self.isFirstPlayersTurn.value && self.isPlaying.value) {
                    self.secondPlayerTimer.incrementTime(seconds: 1)
                }
            }.store(in: &disposables)
        self.secondPlayerSeconds
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else {return}
                if (!self.isFirstPlayersTurn.value && self.isPlaying.value) {
                    self.firstPlayerTimer.incrementTime(seconds: 1)
                }
            }.store(in: &disposables)
    }
    
    override func changingFromFirstToSecond() {
        addTimeIfNeeded(self.firstPlayerTimer)
    }
    
    override func changingFromSecondToFirst() {
        addTimeIfNeeded(self.secondPlayerTimer)
    }
    
}
