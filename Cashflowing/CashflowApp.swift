//
//  CashflowApp.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import SwiftUI

@main
struct CashflowApp: App {
    @StateObject private var store: FlowStore = FlowStore()
    @State var isFirstOpening: Bool = UserDefaults.standard.string(forKey: "isFirstOpening") == "false" ? false : true
    
    init() {
        if UserDefaults.standard.string(forKey: "isFirstOpening") == nil {
            UserDefaults.standard.setValue("true", forKey: "isFirstOpening")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isFirstOpening {
                TutorialView(isFirstOpening: $isFirstOpening)
            } else {
                HomeView(store: store)
                    .task {
                        do {
                            try await store.getFlows()
                        } catch {
                            fatalError("Failed to load flows: \(error)")
                        }
                    }
                    .onAppear {
                        store.locale = store.loadSavedLocale()
                    }
            }
        }
    }
}
