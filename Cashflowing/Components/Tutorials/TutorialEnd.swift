//
//  TutorialEnd.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct TutorialEnd: View {
    var action: ()->Void
    
    var body: some View {
        VStack {
            Text("End")
            NextButton(action: action, isEnding: true)
        }
    }
}

#Preview {
    TutorialEnd(action: {})
}
