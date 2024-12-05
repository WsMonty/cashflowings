//
//  FlowTableRow.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 06.08.24.
//

import SwiftUI

struct FlowTableRow: View {
    var flow: Flow
    var locale: Locale
    
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
                    Text("\(formatAmountString())")
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 3)
              Spacer()
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
    
    private func truncateWithEllipsis(_ input: String, limit: Int = 40) -> String {
        if input.count > limit {
            let endIndex = input.index(input.startIndex, offsetBy: limit)
            return String(input[..<endIndex]) + "..."
        } else {
            return input
        }
    }
    
    private func isGermanLocale() -> Bool {
        return locale.identifier.contains("de_DE")
    }
    
    private func formatAmountString() -> String {
        if isGermanLocale() {
            return flow.amountStringWithComma
        }
        return flow.amountString
    }
}

#Preview {
    FlowTableRow(flow: Flow(amount: 100, description: "Concert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert paymentConcert payment"), locale: availableLocales[1].locale)
        .background(.income)
}
