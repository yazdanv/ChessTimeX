//
//  OrientationExtension.swift
//  ChessTimeX
//
//  Created by Yazdan on 6/13/22.
//

import Foundation
import SwiftUI

struct DetectOrientation: ViewModifier {
    
    @Binding var orientation: UIDeviceOrientation
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                if (UIDevice.current.orientation.isValidInterfaceOrientation) {
                    orientation = UIDevice.current.orientation
                }
            }
    }
}

extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DetectOrientation(orientation: orientation))
    }
}
