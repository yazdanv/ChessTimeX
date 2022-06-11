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
        return hours > 0 ? String(format:"%02i:%02i:%02i", hours, minutes, seconds):String(format:"%02i:%02i", minutes, seconds)
    }
    
    var formattedTimeString: String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        return "\(hours > 0 ? (String(hours) + "h "):"")\(minutes > 0 ? (String(minutes) + "m "):"")\(seconds > 0 ? (String(seconds) + "s"):"")"
    }
    
}
