//
//  StyledButton.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 08.08.24.
//

import SwiftUI

struct StyledButton: View {
    @Binding var isSheetOpen: Bool
    var action: ()->Void
    var buttonText: LocalizedStringKey
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(.callout)
        }
        .padding(10)
        .background(.expense)
        .cornerRadius(GlobalValues.cornerRadius)
    }
}

#Preview {
    StyledButton(isSheetOpen: .constant(false), action: {}, buttonText: "Test Button")
}
