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
    
    let sampleGameRule10Fisher = GameRule(name: "",
                                  gameType: .classic,
                                  firstPlayerSeconds: 300,
                                  secondPlayerSeconds: 300,
                                  incrementType: .fisher,
                                  incrementSeconds: 10)
    
    let sampleGameRuleHourglass = GameRule(name: "",
                                  gameType: .hourglass,
                                  firstPlayerSeconds: 300,
                                  secondPlayerSeconds: 300,
                                  incrementType: .none,
                                  incrementSeconds: 0)
    
    override func setUp() {
        super.setUp()
        disposables = []
    }
    
    func testTimersSetProperly() {
        let game = SampleGameWithoutIncrement(gameRule: sampleGameRule)
        XCTAssertEqual(game.firstPlayerSeconds.value, sampleGameRule.firstPlayerSeconds)
        XCTAssertEqual(game.secondPlayerSeconds.value, sampleGameRule.secondPlayerSeconds)
    }
    
    func testPlayMethodSetsToisPlaying() {
        let game = SampleGameWithoutIncrement(gameRule: sampleGameRule)
        
        game.pause()
        testPublisherTillMatch(game.isPlaying, timeout: 1,
                            assertMessage: "isPlaying did not set correctly",
                            runBeforeWait: game.play) { $0 }
    }
    
    func testChangeToPlayerMakesItActiveWhilePlaying() {
        let game = SampleGameWithoutIncrement(gameRule: sampleGameRule)
        
        game.play()
        testPublisherTillMatch(game.secondTimerActive, timeout: 1,
                            assertMessage: "Second player did not become active",
                            runBeforeWait: game.changeToSecondPlayer) { $0 }
        testPublisherTillMatch(game.firstTimerActive, timeout: 1,
                            assertMessage: "First player did not become active",
                            runBeforeWait: game.changeToFirstPlayer) { $0 }
    }
    
    func testPlayerTimersDecreaseTimeProperly() throws {
        let game = SampleGameWithoutIncrement(gameRule: sampleGameRule)
        let firstPlayerSeconds = sampleGameRule.firstPlayerSeconds
        let secondPlayerSeconds = sampleGameRule.secondPlayerSeconds
        
        testPublisherTillMatch(game.firstPlayerSeconds,
                               assertMessage: "First player time not decreased",
                               runBeforeWait: game.play) {$0 < firstPlayerSeconds}
        testPublisherTillMatch(game.secondPlayerSeconds,
                               assertMessage: "Second player time not decreased",
                               runBeforeWait: game.changeToSecondPlayer) {$0 < secondPlayerSeconds}
    }

    func testPlayerTimersIncreaseFisherTimeProperly() throws {
        let game = SampleGameWithIncrement(gameRule: sampleGameRule10Fisher)
        let firstPlayerSeconds = sampleGameRule10Fisher.firstPlayerSeconds
        let secondPlayerSeconds = sampleGameRule10Fisher.secondPlayerSeconds
        
        game.play()
        testPublisherTillMatch(game.firstPlayerSeconds,
                               assertMessage: "First player time not increased",
                               runBeforeWait: game.changeToSecondPlayer) {$0 > firstPlayerSeconds}
        testPublisherTillMatch(game.secondPlayerSeconds,
                               assertMessage: "Second player time not increased",
                               runBeforeWait: game.changeToFirstPlayer) {$0 > secondPlayerSeconds}
    }
    
    func testPlayerTimersIncreaseHourglassTimeProperly() throws {
        let game = HourglassGame(gameRule: sampleGameRule)
        
        
        let firstPlayerSeconds = game.firstPlayerSeconds.value
        game.play()
        testPublisherTillMatch(game.firstPlayerSeconds,
                               assertMessage: "First player time not increased",
                               runBeforeWait: game.changeToSecondPlayer) {$0 > firstPlayerSeconds}
        let secondPlayerSeconds = game.secondPlayerSeconds.value
        testPublisherTillMatch(game.secondPlayerSeconds,
                               assertMessage: "Second player time not increased",
                               runBeforeWait: game.changeToFirstPlayer) {$0 > secondPlayerSeconds}
    }

}
