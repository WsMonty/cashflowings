//
//  TutorialFlowEntry.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct TutorialFlowEntry: View {
    var action: ()->Void
    
    var body: some View {
        VStack {
            Text("Entry")
            NextButton(action: action)
        }
    }
}

#Preview {
    TutorialFlowEntry(action: {})
}
