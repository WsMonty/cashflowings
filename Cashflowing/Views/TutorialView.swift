//
//  TutorialView.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 09.08.24.
//

import SwiftUI

enum Steps {
    case welcome
    case flowEntry
    case swipeAction
    case settings
    case endTutorial
}

struct TutorialView: View {
    @State private var step: Steps = .welcome
    @Binding var isFirstOpening: Bool
    
    var body: some View {
        ZStack {
            Color.mainBG
                .ignoresSafeArea()
            switch step {
            case .welcome: TutorialWelcome(action: { step = .flowEntry })
            case .flowEntry: TutorialFlowEntry(action: { step = .swipeAction })
            case .swipeAction: TutorialSwipeAction(action: { step = .settings })
            case .settings: TutorialSettings(action: { step = .endTutorial })
            case .endTutorial: TutorialEnd(action: {
                UserDefaults.standard.set("false", forKey: "isFirstOpening")
                isFirstOpening = false
            })
            }
        }
        .foregroundStyle(.mainText)
    }
}

#Preview {
    TutorialView(isFirstOpening: .constant(true))
}
