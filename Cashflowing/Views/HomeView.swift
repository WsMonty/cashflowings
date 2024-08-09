//
//  HomeView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var store: FlowStore
    @State var isSettingsOpen: Bool = false
    
    init(store: FlowStore) {
        self.store = store
        UIBarButtonItem.appearance().tintColor = .mainText
    }
    
    var body: some View {
            NavigationStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        TotalAmount(store: store)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                        FlowsTableView(store: store)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        Divider()
                        AddNewFlow(store: store, isEditMode: false, isEditSheetOpen: .constant(false), editedFlow: .constant(Flow(amount: 0.00)))
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                    }
                    .background(.mainBG)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .toolbar {
                        Button(action: { isSettingsOpen = true }) {
                            Image(systemName: "gear")
                        }
                        .foregroundColor(.mainText)
                    }
                }
                .sheet(isPresented: $isSettingsOpen) {
                    SettingsView(store: store, isSettingsOpen: $isSettingsOpen)
                }
            }
            .environment(\.locale, store.locale)
            .background(.mainBG)
            .foregroundColor(.mainText)
        }
}

#Preview {
    HomeView(store: FlowStore())
}
