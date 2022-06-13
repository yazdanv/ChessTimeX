//
//  GameViewModel.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
 
    @Published var isPlaying = false
    @Published var selectedGameRule: GameRule?
    
    var firstPlayerState = TimerViewModel()
    var secondPlayerState = TimerViewModel()
    
    private var game: GameProtocol!
    private var disposables = Set<AnyCancellable>()
    
    init() {
        bindGameRule()
    }
    
    // Create a different game object based on the type provided
    func setGame(gameRule: GameRule) {
        switch gameRule.gameType {
        case .classic:
            game = ClassicGame(gameRule: gameRule)
        case .hourglass:
            game = HourglassGame(gameRule: gameRule)
        }
        bindPublishers()
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
    
    
    // MARK: subscribing to required publishers
    private func bindGameRule() {
        $selectedGameRule
            .sink { [weak self] gameRule in
                guard let self = self else {return}
                guard let gameRule = gameRule else {return}
                self.setGame(gameRule: gameRule)
            }.store(in: &disposables)
        selectedGameRule = DefaultGameRule.defaultRule
    }

    // Binding the model publishers to view publishers rather than using the game struct
    //   publishers directly inside view, to make sure model side and view side are only
    //   attached using view model and therefore completly detachable
    private func bindPublishers() {
        game.isPlaying
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] isPlaying in
                self?.isPlaying = isPlaying
            }.store(in: &disposables)
        
        game.firstTimerActive
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] isActive in
                self?.firstPlayerState.updateActiveState(isActive)
            }.store(in: &disposables)
        game.firstPlayerSeconds
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] timeSeconds in
                self?.firstPlayerState.setShowTime(timeSeconds)
            }.store(in: &disposables)
        game.firstPlayerNoOfMoves
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] noOfMoves in
                self?.firstPlayerState.setNumberOfMoves(noOfMoves)
            }.store(in: &disposables)
        
        game.secondTimerActive
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] isActive in
                self?.secondPlayerState.updateActiveState(isActive)
            }.store(in: &disposables)
        game.secondPlayerSeconds
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] timeSeconds in
                self?.secondPlayerState.setShowTime(timeSeconds)
            }.store(in: &disposables)
        game.secondPlayerNoOfMoves
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] noOfMoves in
                self?.secondPlayerState.setNumberOfMoves(noOfMoves)
            }.store(in: &disposables)
    }

}
