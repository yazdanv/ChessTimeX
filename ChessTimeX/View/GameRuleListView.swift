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
    @Binding var currentViewShown: Bool
    @Binding var newRuleViewShown: Bool
    
    var body: some View {
        ZStack {
            Color(uiColor: .gray.withAlphaComponent(0.5))
                .onTapGesture {
                    currentViewShown = false
                }
            VStack {
                List(DefaultGameRule.defaultRules, id: \.self) { rule in
                    HStack {
                        Image(systemName: rule.iconImage)
                        Text(rule.title).onTapGesture {
                            selectedGameRule = rule
                        }
                    }
                }
                .navigationTitle("Game Rule")
                Button("New Custom Game") {
                    currentViewShown = false
                    newRuleViewShown = true
                }
                .padding(8)
            }
            .background(.white)
            .cornerRadius(10)
            .padding(EdgeInsets.init(top: 48, leading: 16, bottom: 48, trailing: 16))
        }
    }
}
