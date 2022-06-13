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
    @Binding var sameAsFirst: Bool
    
    private let sameAsFirstShow: Bool
    
    init(title: String, selectedSeconds: Binding<Int>, sameAsFirst: Binding<Bool>? = nil) {
        self.title = title
        self._selectedSeconds = selectedSeconds
        if let sameAsFirst = sameAsFirst {
            self._sameAsFirst = sameAsFirst
            self.sameAsFirstShow = true
        } else {
            self._sameAsFirst = Binding.constant(false)
            self.sameAsFirstShow = false
        }
    }
    
    
    @State var seconds: Int = 0
    @State var minutes: Int = 0
    @State var hours: Int = 0
    
    func buildDatePickerWheel(label: String, selection: Binding<Int>) -> some View {
        return Group {
            DurationWheelPicker(selection: selection, onSelection: {
                selectedSeconds = hours * 3600 + minutes * 60 + seconds
            })
            .frame(height: 50, alignment: .center)
            Text(label).padding(.trailing, 4)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                    .padding(4)
                Spacer()
                if (sameAsFirstShow) {
                    Picker("Same as First", selection: _sameAsFirst) {
                        Text("Same as First").tag(true)
                        Text("Choose").tag(false)
                    }.pickerStyle(.menu)
                }
            }
            if (!sameAsFirst) {
                HStack(spacing: 0) {
                    buildDatePickerWheel(label: "h", selection: $hours)
                    buildDatePickerWheel(label: "m", selection: $minutes)
                    buildDatePickerWheel(label: "s", selection: $seconds)
                }
            }
        }
    }
    
}
