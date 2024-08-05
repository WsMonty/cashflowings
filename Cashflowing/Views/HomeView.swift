//
//  HomeView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var store: FlowStore
    @Binding var flows: [Flow]
    @State var isSettingsOpen: Bool = false
    
    var body: some View {
            NavigationStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        TotalAmount(flows: $flows)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                            .background(Color.gray.opacity(0.05))

                        FlowsTableView(flows: $flows)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                            .background(Color.gray.opacity(0.05))
                        Divider()
                        AddNewFlow(store: store)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .background(Color.gray.opacity(0.05))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .toolbar {
                        Button(action: { isSettingsOpen = true }) {
                            Image(systemName: "gear")
                        }
                    }
                }
                .sheet(isPresented: $isSettingsOpen) {
                    SettingsView(store: store)
                }
            }
        }
        
       
}

#Preview {
    HomeView(store: FlowStore(), flows: .constant(Flow.sampleData))
}
