//
//  GameProtocol.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation
import Combine

class ClassicGame: BaseGame, IncrementTypeProtocol {
    
    override func changingFromFirstToSecond() {
        addTimeIfNeeded(self.firstPlayerTimer)
    }
    
    override func changingFromSecondToFirst() {
        addTimeIfNeeded(self.secondPlayerTimer)
    }
    
}
