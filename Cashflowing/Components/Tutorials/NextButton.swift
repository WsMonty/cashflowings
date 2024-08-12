//
//  NextButton.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct NextButton: View {
    var action: ()->Void
    var label: LocalizedStringKey = "Next"
    var iconName: String = "arrow.forward.square"
    var isEnding: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(isEnding ? "Start" : label)
            Image(systemName: isEnding ? "forward" : iconName)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.expense)
        .cornerRadius(GlobalValues.cornerRadius)
    }
}

#Preview {
    NextButton(action: {})
}
