//
//  CustomGameRuleView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import SwiftUI


struct CustomGameRuleView: View {
    
    @Binding var newGameRule: GameRule?
    @Binding var currentViewShown: Bool
    
    @State var name: String = ""
    @State var gameType: GameType = .classic
    @State var firstPlayerSeconds: Int = 0
    @State var secondPlayerSeconds: Int = 0
    @State var incrementType: IncrementType = .none
    @State var incrementSeconds: Int = 0
    
    var body: some View {
        return ZStack {
            Color(uiColor: .gray.withAlphaComponent(0.5))
                .onTapGesture {
                    currentViewShown = false
                }
            ZStack {
                Color.white
                VStack {
                    Text("Create Custom Game Rule")
                        .font(.headline)
                        .bold()
                        .padding(8)
                    Form {
                        TextField("Game Name (Optional)", text: $name)
                        Picker("Game Type", selection: $gameType) {
                            ForEach(GameType.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }.pickerStyle(.menu)
                        DurationPickerView(title: "First Player Time", selectedSeconds: $firstPlayerSeconds)
                        DurationPickerView(title: "Second Player Time", selectedSeconds: $secondPlayerSeconds)
                        Picker("Increment Type", selection: $incrementType) {
                            ForEach(IncrementType.allCases, id: \.self) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }.pickerStyle(.menu)
                        if (incrementType != .none) {
                            DurationPickerView(title: "Increment Time", selectedSeconds: $incrementSeconds)
                        }
                    }
                    .padding(8)
                    Spacer()
                    Button("Create") {
                        newGameRule = GameRule(name: name, gameType: gameType,
                                               firstPlayerSeconds: firstPlayerSeconds,
                                               secondPlayerSeconds: secondPlayerSeconds,
                                               incrementType: incrementType,
                                               incrementSeconds: incrementSeconds)
                    }
                    .padding(8)
                }
            }
            .cornerRadius(10)
            .frame(height: 600, alignment: .center)
            .padding(EdgeInsets.init(top: 0, leading: 32, bottom: 0, trailing: 32))
        }
    }
    
}
