//
//  ChessTimeXTests.swift
//  ChessTimeXTests
//
//  Created by Yazdan on 6/9/22.
//

import XCTest
import Combine
@testable import ChessTimeX

class GameTests: XCTestCase {

    private var disposables: Set<AnyCancellable>!
    
    let sampleGameRule = GameRule(name: "",
                                  gameType: .classic,
                                  firstPlayerSeconds: 300,
                                  secondPlayerSeconds: 300,
                                  incrementType: .none,
                                  incrementSeconds: 0)
    
    override func setUp() {
        super.setUp()
        disposables = []
    }
    
    func testTimersSetProperly() {
        let game = BaseGame(gameRule: sampleGameRule)
        XCTAssertEqual(game.firstPlayerSeconds.value, sampleGameRule.firstPlayerSeconds)
        XCTAssertEqual(game.secondPlayerSeconds.value, sampleGameRule.secondPlayerSeconds)
    }
    
    func testPlayMethodSetsToisPlaying() {
        let game = BaseGame(gameRule: sampleGameRule)
        
        game.pause()
        testPublisherTillMatch(game.isPlaying, timeout: 1,
                            assertMessage: "isPlaying did not set correctly",
                            runBeforeWait: game.play) { $0 }
    }
    
    func testChangeToPlayerMakesItActiveWhilePlaying() {
        let game = BaseGame(gameRule: sampleGameRule)
        
        game.play()
        testPublisherTillMatch(game.secondTimerActive, timeout: 1,
                            assertMessage: "Second player did not become active",
                            runBeforeWait: game.changeToSecondPlayer) { $0 }
        testPublisherTillMatch(game.firstTimerActive, timeout: 1,
                            assertMessage: "First player did not become active",
                            runBeforeWait: game.changeToFirstPlayer) { $0 }
    }
    
    func testPlayerTimersDecreaseTimeProperly() throws {
        let game = BaseGame(gameRule: sampleGameRule)
        let firstPlayerSeconds = sampleGameRule.firstPlayerSeconds
        let secondPlayerSeconds = sampleGameRule.secondPlayerSeconds
        
        testPublisherTillMatch(game.firstPlayerSeconds,
                               assertMessage: "First player time not decreased",
                               runBeforeWait: game.play) {$0 < firstPlayerSeconds}
        testPublisherTillMatch(game.secondPlayerSeconds,
                               assertMessage: "Second player time not decreased",
                               runBeforeWait: game.changeToSecondPlayer) {$0 < secondPlayerSeconds}
    }

}
