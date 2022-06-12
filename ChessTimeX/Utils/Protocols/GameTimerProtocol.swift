//
//  GameTimerProtocol.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/11/22.
//

import Foundation
import Combine

protocol GameTimerProtocol {
    var timeSeconds: CurrentValueSubject<Int, Never> { get }
    var isRunning: CurrentValueSubject<Bool, Never> { get }
    
    func resetTimer(seconds: Int)
    func incrementTime(seconds: Int)
    
    func startTimer()
    func stopTimer()
}
