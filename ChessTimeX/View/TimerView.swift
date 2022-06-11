//
//  TimerView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/11/22.
//

import Foundation
import SwiftUI
import Combine

struct TimerView: View {
    
    let gameRule: GameRule?
    
    @ObservedObject var timerViewModel: TimerViewModel
    
    let onTap: () -> Void
    let rotation: Double
    
    var body: some View {
        return ZStack {
            (timerViewModel.isTimerActive ? Color(red: 1, green: 0.8, blue: 0):Color.brown)
                .shadow(radius: 5)
                .cornerRadius(10)
            VStack {
                Text(gameRule?.nameTitle ?? "").font(.title).bold()
                Spacer()
            }
            .padding(16)
            
            Text(timerViewModel.playerShowTime)
                .font(.largeTitle.bold())
                .foregroundColor(timerViewModel.isTimerActive ? .primary:.secondary)
        }
            .onTapGesture(perform: onTap)
            .padding(12)
            .rotationEffect(.degrees(rotation))
    }
    
}
