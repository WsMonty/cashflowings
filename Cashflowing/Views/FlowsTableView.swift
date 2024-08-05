//
//  FlowsTable.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct FlowsTableView: View {
    @Binding var flows: [Flow]
    
    private func getTextColor(type: FlowType) -> Color {
        return type == .income ? .income : .expense
    }
    
    var body: some View {
        NavigationStack {
            List(flows.sorted(by: { $0.date < $1.date }), id: \.id) { flow in
                NavigationLink(destination: FlowDetailView(flow: flow)) {
                    HStack {
                        Text("\(flow.dateString): \(flow.amountString)")
                        Text("\(flow.descriptionEmoji) \(truncateWithEllipsis(flow.description))")
                            .font(.caption)
                    }
                }
                .listRowBackground(getTextColor(type: flow.type))
            }
             .scrollContentBackground(.hidden) 
        }
    }
    
    func truncateWithEllipsis(_ input: String, limit: Int = 15) -> String {
        if input.count > limit {
            let endIndex = input.index(input.startIndex, offsetBy: limit)
            return String(input[..<endIndex]) + "..."
        } else {
            return input
        }
    }
}

#Preview {
    FlowsTableView(flows: .constant(Flow.sampleData))
}

