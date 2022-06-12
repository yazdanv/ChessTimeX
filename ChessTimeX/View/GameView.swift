//
//  GameView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    @State private var gameRuleSelectShown: Bool = false
    @State private var gameRuleNewShown: Bool = false
    
    init() {
        viewModel = GameViewModel()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TimerView(gameRule: viewModel.selectedGameRule,
                          timerViewModel: viewModel.firstPlayerState,
                          onTap: viewModel.firstPlayerTapped,
                          rotation: 180
                )
                actionBar
                TimerView(gameRule: viewModel.selectedGameRule,
                          timerViewModel: viewModel.secondPlayerState,
                          onTap: viewModel.secondPlayerTapped,
                          rotation: 0
                )
            }
            .background(.ultraThinMaterial)
            if (gameRuleSelectShown) {
                GameRuleListView(selectedGameRule: $viewModel.selectedGameRule,
                                currentViewShown: $gameRuleSelectShown,
                                newRuleViewShown: $gameRuleNewShown)
            }
            if (gameRuleNewShown) {
                CustomGameRuleView(newGameRule: $viewModel.selectedGameRule,
                                  currentViewShown: $gameRuleNewShown)
            }
        }
        .onReceive(viewModel.$selectedGameRule, perform: { _ in
            gameRuleSelectShown = false
            gameRuleNewShown = false
        })
    }
}

private extension GameView {
    var actionBar: some View {
        return HStack(alignment: .center) {
            Button(action: {
                gameRuleSelectShown = true
            }) {
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
