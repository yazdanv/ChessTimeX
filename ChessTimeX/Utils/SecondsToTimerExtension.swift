//
//  SecondsToTimerExtension.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/10/22.
//

import Foundation

extension Int {
    
    var timerString: String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        return "\(hours):\(minutes):\(seconds)"
    }
    
}
