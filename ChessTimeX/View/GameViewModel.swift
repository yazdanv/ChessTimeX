//
//  GameViewModel.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
 
    // Variables for conformance to Game Protocol
    // Implementation inside the extension to GameViewModel
    var firstPlayerTimer: GameTimerProtocol?
    var secondPlayerTimer: GameTimerProtocol?
    
    @Published var isPlaying = false
    @Published var firstPlayersTurn = true
    @Published var firstPlayerShowTime = "00:05:00"
    @Published var secondPlayerShowTime = "00:05:00"
    
    init() {

    }
    
}

extension GameViewModel: GameProtocol {
    
}
