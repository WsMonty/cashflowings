//
//  TutorialWelcome.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct TutorialWelcome: View {
    var action: ()->Void
    
    var body: some View {
        VStack {
            Text("Welcome")
            Button(action: action) {
                Text("next")
            }
        }
    }
}

#Preview {
    TutorialWelcome(action: {})
}
