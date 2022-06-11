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
                TimerView(timerViewModel: viewModel.firstPlayerState,
                          onTap: viewModel.firstPlayerTapped,
                          rotation: 180
                )
                actionBar
                TimerView(timerViewModel: viewModel.secondPlayerState,
                          onTap: viewModel.secondPlayerTapped,
                          rotation: 0
                )
            }
            .background(.ultraThinMaterial)
        }
    }
}

private extension GameView {
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
