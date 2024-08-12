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
            HStack {
                Text("welcomeText")
                Spacer()
            }
           NextButton(action: action)
            Spacer()
        }
        .padding()
        .foregroundStyle(.mainText)
        .background(.mainBG)
    }
}

#Preview {
    TutorialWelcome(action: {})
}
