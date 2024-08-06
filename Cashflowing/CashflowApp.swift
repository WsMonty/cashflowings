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
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: store)
                .task {
                    do {
                        try await store.getFlows()
                    } catch {
                        fatalError("Failed to load flows: \(error)")
                    }
                }
        }
    }
    
}
