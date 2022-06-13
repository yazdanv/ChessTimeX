//
//  SubscriptionContainer.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import Foundation
import Combine

// Using disposables as it's own class ensures that our structs could store their
//   subscriptions without mutating itself and also this class is not that expensive
//   and easily freeable by arc because it would not have that many refrences and
//   no strong refrence cycles could occur
class Disposables {
    
    var items = Set<AnyCancellable>()
    
    func cancelAll() {
        items.forEach {
            $0.cancel()
        }
    }
    
}
