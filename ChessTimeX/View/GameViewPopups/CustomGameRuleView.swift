//
//  CustomGameRuleView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import SwiftUI


struct CustomGameRuleView: View {
    
    @Binding var newGameRule: GameRule?
    let showAlert: ((GameViewActiveAlert) -> Void)
    let hideCurrent: (() -> Void)
    
    @State var name: String = ""
    @State var gameType: GameType = .classic
    @State var firstPlayerSeconds: Int = 0
    @State var secondPlayerSeconds: Int = 0
    @State var secondPlayerSameAsFirst: Bool = true
    @State var incrementType: IncrementType = .none
    @State var incrementSeconds: Int = 0
    
    var body: some View {
        return ZStack {
            Color(uiColor: .gray.withAlphaComponent(0.5))
                .onTapGesture(perform: hideCurrent)
            ZStack {
                VStack {
                    Text("Create Custom Game Rule")
                        .font(.headline)
                        .bold()
                        .padding(8)
                    Form {
                        TextField("Game Name (Optional)", text: $name)
                        
                        HStack {
                            Text("Game Type: ").font(.system(size: 18)).foregroundStyle(.gray)
                            Picker("Game Type", selection: $gameType) {
                                ForEach(GameType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                        .tag($0)
                                }
                            }.pickerStyle(.menu)
                        }
                        
                        DurationPickerView(title: "First Player Time", selectedSeconds: $firstPlayerSeconds)
                        DurationPickerView(title: "Second Player Time", selectedSeconds: $secondPlayerSeconds, sameAsFirst: $secondPlayerSameAsFirst)
                        
                        HStack {
                            Text("Increment Type: ").font(.system(size: 18)).foregroundStyle(.gray)
                            Picker("Increment Type", selection: $incrementType) {
                                ForEach(IncrementType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                        .tag($0)
                                }
                            }.pickerStyle(.menu)
                        }
                        if (incrementType != .none) {
                            DurationPickerView(title: "Increment Time", selectedSeconds: $incrementSeconds)
                        }
                    }
                    .padding(8)
                    Spacer()
                    HStack {
                        Button("Cancel", action: hideCurrent)
                            .frame(maxWidth: .infinity)
                        Rectangle()
                            .background(.gray)
                            .frame(width: 0.5, height: 30)
                        Button("Create") {
                            if (firstPlayerSeconds == 0
                                || secondPlayerSeconds == 0 && !secondPlayerSameAsFirst
                                || incrementSeconds == 0 && incrementType != .none) {
                                showAlert(.timeInvalid)
                            } else {
                                newGameRule = GameRule(name: name, gameType: gameType,
                                                       firstPlayerSeconds: firstPlayerSeconds,
                                                       secondPlayerSeconds: secondPlayerSameAsFirst ? firstPlayerSeconds:secondPlayerSeconds,
                                                       incrementType: incrementType,
                                                       incrementSeconds: incrementSeconds)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(8)
                }
            }
            .background(.bar)
            .cornerRadius(10)
            .frame(maxWidth: 350, maxHeight: 600)
            .padding(8)
        }

    }
    
}
