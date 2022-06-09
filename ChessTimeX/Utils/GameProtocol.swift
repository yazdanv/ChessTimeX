//
//  GameProtocol.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/9/22.
//

import Foundation

protocol GameProtocol {
    var firstPlayerTimer: GameTimerProtocol? { get set }
    var secondPlayerTimer: GameTimerProtocol? { get set }
}
