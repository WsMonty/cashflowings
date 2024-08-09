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
            Button(action: action) {
                Text("next")
            }
        }
    }
}

#Preview {
    TutorialEnd(action: {})
}
