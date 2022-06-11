//
//  GameViewModel.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
 
    var game: GameProtocol!
    
    var disposables = Set<AnyCancellable>()
    
    @Published var isPlaying = false
    @Published var isFirstPlayersTurn = true
    @Published var firstPlayerShowTime = "00:05:00"
    @Published var secondPlayerShowTime = "00:05:00"
    
    init() {
        setGame(gameRule: DefaultGameRule.defaultRule)
        // Binding the model publishers to view publishers rather than using the game object
        //   publishers directly inside view, to make sure model side and view side are only
        //   attached using view model and therefore completly detachable
        bindPublishers()
    }
    
    // Create a different game object based on the type provided
    func setGame(gameRule: GameRule) {
        switch gameRule.gameType {
        case .classic:
            game = ClassicGame(gameRule: gameRule)
        case .hourglass:
            game = HourglassGame(gameRule: gameRule)
        }
    }
    
    func play() {
        game.play()
    }
    
    func pause() {
        game.pause()
    }
    
    func resetGame() {
        game.reset()
    }
    
    func firstPlayerTapped() {
        game.changeToSecondPlayer()
    }
    
    func secondPlayerTapped() {
        game.changeToFirstPlayer()
    }
    

    func bindPublishers() {
        game.isPlaying
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] isPlaying in
                self?.isPlaying = isPlaying
            }.store(in: &disposables)
        game.isFirstPlayersTurn
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] isFirstPlayersTurn in
                self?.isFirstPlayersTurn = isFirstPlayersTurn
            }.store(in: &disposables)
        game.firstPlayerSeconds
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .map { $0 > 0 ? $0.timerString:"Player 1 Time Finished" }
            .sink { [weak self] timeString in
                self?.firstPlayerShowTime = timeString
            }.store(in: &disposables)
        game.secondPlayerSeconds
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .map { $0 > 0 ? $0.timerString:"Player 2 Time Finished" }
            .sink { [weak self] timeString in
                self?.secondPlayerShowTime = timeString
            }.store(in: &disposables)
    }

}
