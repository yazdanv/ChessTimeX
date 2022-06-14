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
    
    let hideCurrent: (() -> Void)
    let showNewRule: (() -> Void)
    
    var body: some View {
        ZStack {
            Color(uiColor: .gray.withAlphaComponent(0.3))
            VStack {
                Text("Select Game Rule")
                    .font(.headline)
                    .bold()
                    .padding(8)
                List(DefaultGameRule.defaultRules, id: \.self) { rule in
                    HStack {
                        Image(systemName: rule.iconImage)
                        Text(rule.title).onTapGesture {
                            selectedGameRule = rule
                        }
                    }
                }
                .navigationTitle("Game Rule")
                HStack(alignment: .center, spacing: 0) {
                    Button("Cancel", action: hideCurrent)
                        .frame(maxWidth: .infinity)
                    Rectangle()
                        .background(.gray)
                        .frame(width: 0.5, height: 30)
                    Button("Custom Game") {
                        hideCurrent()
                        showNewRule()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(8)
            }
            .background(.bar)
            .cornerRadius(10)
            .padding(EdgeInsets.init(top: 48, leading: 16, bottom: 48, trailing: 16))
        }
    }
}
