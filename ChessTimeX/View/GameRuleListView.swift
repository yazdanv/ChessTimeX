//
//  GameRuleListView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/11/22.
//

import Foundation
import SwiftUI
import Combine

struct GameRuleListView: View {
    @Binding var selectedGameRule: GameRule?
    
    var body: some View {
        VStack {
            List(DefaultGameRule.defaultRules, id: \.self) { rule in
                Text(rule.title).onTapGesture {
                    selectedGameRule = rule
                }
            }
            .navigationTitle("Game Rule")
        }
        .background(.white)
        .cornerRadius(10)
        .padding(EdgeInsets.init(top: 48, leading: 16, bottom: 48, trailing: 16))

    }
}
