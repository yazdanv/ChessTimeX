//
//  GameView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    init() {
        viewModel = GameViewModel()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                timerView(time: viewModel.firstPlayerShowTime,
                          isActive: viewModel.isFirstPlayersTurn && viewModel.isPlaying,
                          onTap: viewModel.firstPlayerTapped,
                          rotation: 180
                )
                actionBar
                timerView(time: viewModel.secondPlayerShowTime,
                          isActive: !viewModel.isFirstPlayersTurn && viewModel.isPlaying,
                          onTap: viewModel.secondPlayerTapped
                )
            }
            .background(.ultraThinMaterial)
        }
    }
}

private extension GameView {
    
    func timerView(time: String, isActive: Bool, onTap: @escaping  (() -> Void), rotation: Double = 0) -> some View {
        return ZStack {
            (isActive ? Color(red: 1, green: 0.8, blue: 0):Color.brown)
                .shadow(radius: 5)
                .cornerRadius(10)
            Text(time)
                .font(.largeTitle.bold())
                .foregroundColor(isActive ? .primary:.secondary)
        }
            .onTapGesture(perform: onTap)
            .padding(12)
            .rotationEffect(.degrees(rotation))
    }
    
    var actionBar: some View {
        return HStack(alignment: .center) {
            Button(action: {}) {
                Image(systemName: "timer")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
            Button(action: viewModel.isPlaying ? viewModel.pause:viewModel.play) {
                Image(systemName: viewModel.isPlaying ? "pause":"play")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
            Button(action: viewModel.resetGame) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
        }.padding(12)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
