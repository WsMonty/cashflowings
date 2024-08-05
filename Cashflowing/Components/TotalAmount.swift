//
//  totalAmount.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct TotalAmount: View {
    @Binding var flows: [Flow]
    
    private func getTotalAmount() -> Double {
        let amounts = flows.map { $0.amount }
        
        return amounts.reduce(0, { x, y in
                x + y
        })
    }
    
    var body: some View {
        VStack {
            Text("\(String(format: "%.2f", getTotalAmount())) €")
                .font(.title)
            Text("Total amount")
                .font(.caption)
        }
    }
}

#Preview {
    TotalAmount(flows: .constant(Flow.sampleData))
}
