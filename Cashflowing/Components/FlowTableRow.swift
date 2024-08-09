//
//  FlowTableRow.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 06.08.24.
//

import SwiftUI

struct FlowTableRow: View {
    var flow: Flow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack() {
                    Image(systemName: "calendar")
                    Text("\(flow.dateString)")
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 2.5)
                .padding(.leading, 20)
                HStack {
                    Image(systemName: "dollarsign.square")
                    Text("\(flow.amountString)")
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 3)
              
            }
            if !flow.description.isEmpty {
                Text("\(flow.descriptionEmoji) \(truncateWithEllipsis(flow.description))")
                    .font(.caption)
                    .padding(.leading, 20)
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
    
    private func truncateWithEllipsis(_ input: String, limit: Int = 35) -> String {
        if input.count > limit {
            let endIndex = input.index(input.startIndex, offsetBy: limit)
            return String(input[..<endIndex]) + "..."
        } else {
            return input
        }
    }
}

#Preview {
    FlowTableRow(flow: Flow(amount: 100, description: "Concert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert payment"))
        .background(.income)
        .previewLayout(.fixed(width: 400, height: 60))
}
