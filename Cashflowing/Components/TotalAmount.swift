//
//  totalAmount.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct TotalAmount: View {
    var flows: [Flow]
    var locale: Locale
    
    var body: some View {
        VStack {
            Text("\(getTotalAmount()) \(flows.first?.currency ?? "€")")
                .font(.title)
            Text("Total amount")
                .font(.caption)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
        .foregroundColor(.mainText)
    }
    
    private func getTotalAmount() -> String {
        let amounts = flows.map { $0.amount }
        let sum = amounts.reduce(0, { x, y in
            x + y
        })
        
        return isGermanLocale() ? String(format: "%.2f", sum).replacingOccurrences(of: ".", with: ",") : String(format: "%.2f", sum)
    }
    
    private func isGermanLocale() -> Bool {
        return locale.identifier.contains("de_DE")
    }
    
}

#Preview {
    TotalAmount(flows: Flow.sampleData, locale:availableLocales[0].locale)
        .background(.mainBG)
}
