//
//  AddNewFlow.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct AddNewFlow: View {
    @ObservedObject var store: FlowStore
    @State var amount: String = ""
    @State var date: Date = Date()
    @State var description: String = ""
    
    
    private func addFlow() async {
        let newFlow: Flow = Flow(amount: Double(amount) ?? 0.00, date: date, description: description)
        Task {
            try await store.writeNewFlow(flow: newFlow)
        }
        amount = ""
        date = Date()
        description = ""
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Text("Amount")
                        TextField("0.00", text: $amount)
                            .onChange(of: amount, validateInput)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .background(.greyBG)
                            .cornerRadius(7.5)
                    }
                    .frame(width: geometry.size.width * 0.45)
                    Divider()
                        .frame(maxHeight: 30)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                        .frame(width: geometry.size.width * 0.43)
                    
                }
                TextField("Description", text: Binding(get: {description}, set: {description = String($0)}))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.greyBG)
                    .cornerRadius(7.5)
                Button(action: {
                    Task {
                        await addFlow()
                    }
                    Task {
                        try await store.getFlows()
                    }
                }) {
                    Text("Add \(getButtonText())")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7.5)
                }
                .disabled(amount.isEmpty)
                .background(getBackgroundColor())
                .cornerRadius(7.5)
            }
            .padding()
        }
    }
    
    private func validateInput() {
        let filtered = amount.filter { "0123456789.-".contains($0) }
        var result = filtered
        if filtered.contains(".") {
           let splitString = filtered.split(separator: ".")
            let beforeComma = String(splitString[0])
            let afterComma = splitString.count > 1 ? String(splitString[1].prefix(2)) : ""
            result = "\(beforeComma).\(afterComma)"
        }
        
        amount = result
    }
    
    private func getBackgroundColor() -> Color {
        if amount.isEmpty { return .greyBG }
        return Double(amount) ?? 0.00 >= 0 ? .income : .expense
    }
    
    private func getButtonText() -> String {
        if amount.isEmpty { return "" }
        if (Double(amount) != nil) {
            return Double(amount)! > 0 ? "Income" : "Expense"
        }
        return ""
    }
}


#Preview {
    AddNewFlow(store: FlowStore())
}
    
