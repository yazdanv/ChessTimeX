//
//  GameView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject private var viewModel: GameViewModel
    
    @State private var gameRuleSelectShown: Bool = false
    @State private var gameRuleNewShown: Bool = false
    
    @State private var alertShown: Bool = false
    @State private var activeAlert: GameViewActiveAlert = .gameReset
    
    @State private var orientation = UIDevice.current.orientation
    
    init() {
        viewModel = GameViewModel()
    }
    
    var body: some View {
        let vStackTimers = VStack(spacing: 0) {
            TimerView(gameRule: viewModel.selectedGameRule,
                      timerViewModel: viewModel.firstPlayerState,
                      onTap: viewModel.firstPlayerTapped,
                      rotation: 180
            )
            if (!orientation.isLandscape) {
                horizontalActionBar
            }
            TimerView(gameRule: viewModel.selectedGameRule,
                      timerViewModel: viewModel.secondPlayerState,
                      onTap: viewModel.secondPlayerTapped,
                      rotation: 0
            )
        }
        ZStack {
            if (orientation.isLandscape) {
                HStack {
                    vStackTimers
                    verticalActionBar
                }
                .background(.ultraThinMaterial)
            } else {
                vStackTimers
                    .background(.ultraThinMaterial)
            }
            
            if (gameRuleSelectShown) {
                GameRuleListView(selectedGameRule: $viewModel.selectedGameRule,
                                 hideCurrent: { gameRuleSelectShown = false },
                                 showNewRule: { gameRuleNewShown = true })
            }
            if (gameRuleNewShown) {
                CustomGameRuleView(newGameRule: $viewModel.selectedGameRule,
                                   showAlert: { alertType in
                                        activeAlert = alertType
                                        alertShown = true
                                   },
                                   hideCurrent: { gameRuleNewShown = false })
            }
        }
        .onReceive(viewModel.$selectedGameRule, perform: { _ in
            gameRuleSelectShown = false
            gameRuleNewShown = false
        })
        .alert(isPresented: $alertShown) {
            switch activeAlert {
            case .gameReset:
                return Alert(title: Text("Resetting Game"),
                              message: Text("Are you sure you want to reset this game?"),
                              primaryButton: .default(Text("Yes"), action: viewModel.resetGame),
                              secondaryButton: .cancel(Text("No")))
            case .timeInvalid:
                return Alert(title: Text("Time Invalid"),
                              message: Text("Time should be more than Zero"),
                              dismissButton: .cancel(Text("Ok")))
            }

        }
        .detectOrientation($orientation)
    }
}

private extension GameView {
    var verticalActionBar: some View {
        return VStack {
            actionBarButtonGroup
        }.padding(8)
    }
    
    var horizontalActionBar: some View {
        return HStack {
            actionBarButtonGroup
        }.padding(8)
    }
    
    var actionBarButtonGroup: some View {
        Group {
            Spacer()
            Button(action: {
                viewModel.pause()
                gameRuleSelectShown = true
            }) {
                Image(systemName: ActionBarAssets.timer)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: viewModel.isPlaying ? viewModel.pause:viewModel.play) {
                Image(systemName: viewModel.isPlaying ? ActionBarAssets.pause:ActionBarAssets.play)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {
                viewModel.pause()
                activeAlert = .gameReset
                alertShown = true
            }) {
                Image(systemName: ActionBarAssets.reset)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewInterfaceOrientation(.portrait)
    }
}
