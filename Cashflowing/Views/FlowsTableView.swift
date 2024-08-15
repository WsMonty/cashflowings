//
//  FlowsTable.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct FlowsTableView: View {
    @ObservedObject var store: FlowStore
    
    var flows: [Flow]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    MonthYearFilter(store: store)
                    HStack(spacing: 0) {
                        Button(action: { store.dataType = .allFlows }) {
                            Text("allFlows")
                        }
                        .customButtonStyle(isActive: store.dataType == .allFlows)
                        Button(action: { store.dataType = .income }) {
                            Text("income")
                        }
                        .customButtonStyle(isActive: store.dataType == .income)
                        Button(action: { store.dataType = .expenses }) {
                            Text("expenses")
                        }
                        .customButtonStyle(isActive: store.dataType == .expenses)
                    }
                    .padding(.horizontal, 10)
                }
                
                List(flows, id: \.id) { flow in
                    NavigationLink(destination: FlowDetailView(store: store, flow: flow)) {
                        FlowTableRow(flow: flow, locale: store.locale)
                            .listRowSeparator(.hidden)
                    }
                    .listRowBackground(getTextColor(type: flow.type))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            store.deleteFlow(flow: flow)
                        } label: {
                            Label("Delete", systemImage: "minus.square.fill")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: { store.copiedData = flow }) {
                            Label("Copy", systemImage: "plus.square.on.square")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.horizontal, -10)
            }
            .background(.mainBG)
        }
    }
    
    private func getTextColor(type: FlowType) -> Color {
        return type == .income ? .income : .expense
    }
}

#Preview {
    FlowsTableView(store: FlowStore(), flows: Flow.sampleData)
}

struct CustomButtonStyle: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(width: (UIScreen.main.bounds.width / 3) - 8)
            .background(.clear)
            .overlay(alignment: .bottom) {
                isActive ? Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.blue) : nil
            }
            .foregroundColor(.mainText)
            .cornerRadius(5)
    }
}

extension View {
    func customButtonStyle(isActive: Bool) -> some View {
        self.modifier(CustomButtonStyle(isActive: isActive))
    }
}

