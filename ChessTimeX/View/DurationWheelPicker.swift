//
//  MultiWheelView.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/12/22.
//

import Foundation
import SwiftUI

struct DurationWheelPicker: UIViewRepresentable {
    var selection: Binding<Int>
    let onSelection: (() -> Void)
    
    func makeCoordinator() -> DurationWheelPicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<DurationWheelPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<DurationWheelPicker>) {
        view.selectRow(selection.wrappedValue, inComponent: 0, animated: false)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: DurationWheelPicker
      
        init(_ pickerView: DurationWheelPicker) {
            parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 60
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(format: "%02i", row)
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection.wrappedValue = row
            parent.onSelection()
        }
    }
}
