//
//  DurationPickerView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import SwiftUI

struct DurationPickerView: View {
    
    let title: String
    @Binding var selectedSeconds: Int
    
    @State var seconds: Int = 0
    @State var minutes: Int = 0
    @State var hours: Int = 0
    
    func textTitle(_ input: Int) -> String {
        return input < 10 ? "0\(input)":String(input)
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .padding(4)
            HStack {
                DurationWheelPicker(selection: $hours, onSelection: {
                    selectedSeconds = hours * 3600 + minutes * 60 + seconds
                })
                .frame(height: 50, alignment: .center)
                
                DurationWheelPicker(selection: $minutes, onSelection: {
                    selectedSeconds = hours * 3600 + minutes * 60 + seconds
                })
                .frame(height: 50, alignment: .center)
                
                DurationWheelPicker(selection: $seconds, onSelection: {
                    selectedSeconds = hours * 3600 + minutes * 60 + seconds
                })
                .frame(height: 50, alignment: .center)
            }

        }
    }
    
}
