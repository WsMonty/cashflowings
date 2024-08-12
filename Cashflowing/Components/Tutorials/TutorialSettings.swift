//
//  TutorialSettings.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct TutorialSettings: View {
    var action: ()->Void
    
    var body: some View {
        VStack {
            Text("Settings")
            NextButton(action: action)
        }
    }
}

#Preview {
    TutorialSettings(action: {})
}
