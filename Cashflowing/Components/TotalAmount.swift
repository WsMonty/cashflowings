//
//  totalAmount.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct TotalAmount: View {
    @ObservedObject var store: FlowStore
    
    var body: some View {
        VStack {
            Text("\(getTotalAmount()) \(store.flows.first?.currency ?? "€")")
                .font(.title)
            Text("Total amount")
                .font(.caption)
        }
        .foregroundColor(.mainText)
    }
    
    private func getTotalAmount() -> String {
        let amounts = store.flows.map { $0.amount }
        let sum = amounts.reduce(0, { x, y in
            x + y
        })
        
        return isGermanLocale() ? String(format: "%.2f", sum).replacingOccurrences(of: ".", with: ",") : String(format: "%.2f", sum)
    }
    
    private func isGermanLocale() -> Bool {
        return store.locale.identifier.contains("de_DE")
    }
}

#Preview {
    TotalAmount(store: FlowStore())
        .background(.mainBG)
}
