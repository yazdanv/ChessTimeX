//
//  SubscriptionContainer.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import Foundation
import Combine

class Disposables {
    
    var items = Set<AnyCancellable>()
    
    func cancelAll() {
        items.forEach {
            $0.cancel()
        }
    }
    
}
