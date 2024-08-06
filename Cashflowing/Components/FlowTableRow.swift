//
//  FlowTableRow.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 06.08.24.
//

import SwiftUI

struct FlowTableRow: View {
    var flow: Flow
    @ObservedObject var store: FlowStore
    
    var body: some View {
        NavigationLink(destination: FlowDetailView(store: store, flow: flow)) {
            HStack {
                Text("\(flow.dateString): \(flow.amountString)")
                Text("\(flow.descriptionEmoji) \(truncateWithEllipsis(flow.description))")
                    .font(.caption)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    deleteFlow()
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
        .foregroundColor(.black)
        .listRowBackground(getTextColor(type: flow.type))
       
    }
    
    private func deleteFlow() {
        store.deleteFlow(flow: flow)
    }
    
    private func getTextColor(type: FlowType) -> Color {
        return type == .income ? .income : .expense
    }
    
    private func truncateWithEllipsis(_ input: String, limit: Int = 15) -> String {
        if input.count > limit {
            let endIndex = input.index(input.startIndex, offsetBy: limit)
            return String(input[..<endIndex]) + "..."
        } else {
            return input
        }
    }
}

#Preview {
    FlowTableRow(flow: Flow(amount: 100, description: "Concert payment"), store: FlowStore())
        .background(.income)
}
