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
        let foregroundColor = timerViewModel.isTimerActive ? Color.primary:Color.secondary
        
        return ZStack {
            (timerViewModel.isTimerActive ? Color(red: 1, green: 0.8, blue: 0):Color.brown)
                .shadow(radius: 5)
                .cornerRadius(10)
            VStack {
                HStack {
                    Image(systemName: gameRule?.iconImage ?? "")
                        .foregroundColor(foregroundColor)
                    Text(gameRule?.nameTitle ?? "").font(.title).bold()
                        .foregroundColor(foregroundColor)
                    Text("  |  ").bold()
                        .foregroundColor(foregroundColor)
                    Text(gameRule?.incrementTitle ?? "").bold()
                        .foregroundColor(foregroundColor)
                }
                Spacer()
            }
            .padding(16)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(timerViewModel.numberOfMoves) Moves")
                        .foregroundColor(foregroundColor)
                        .padding(16)
                }
            }
            
            Text(timerViewModel.playerShowTime)
                .font(.system(size: 80))
                .foregroundColor(foregroundColor)
        }
            .onTapGesture(perform: onTap)
            .padding(12)
            .rotationEffect(.degrees(rotation))
    }
    
}
