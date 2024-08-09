//
//  TutorialSwipeAction.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

struct TutorialSwipeAction: View {
    var action: ()->Void
    
    var body: some View {
        VStack {
            Text("Swipe")
            Button(action: action) {
                Text("next")
            }
        }
    }
}

#Preview {
    TutorialSwipeAction(action: {})
}
