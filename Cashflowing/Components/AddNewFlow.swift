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
    var isEditMode: Bool
    var oldFlow: Flow?
    @Binding var isEditSheetOpen: Bool
    @Binding var editedFlow: Flow
    @State private var isDatePickerOpen: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button(action: {
                    Task {
                        if isEditMode {
                            try await store.editFlow(oldFlow: oldFlow!, newFlow: Flow(amount: Double(amount) ?? 0.00, date: date, description: description))
                            editedFlow = Flow(amount: Double(amount) ?? 0.00, date: date, description: description)
                            isEditSheetOpen = false
                            return
                        }
                        await addFlow()
                    }
                }) {
                    Text(getButtonText())
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7.5)
                }
                .disabled(amount.isEmpty)
                .background(getBackgroundColor())
                .cornerRadius(7.5)
                .padding(.bottom, 5)
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
                    .frame(width: UIScreen.main.bounds.width * 0.57)
                    Divider()
                        .frame(maxHeight: 30)
                    Button(action: { isDatePickerOpen = true }) {
                        Text("\(formatDate(date: date))")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 6)
                    .background(.greyBG)
                    .cornerRadius(GlobalValues.cornerRadius)
                    
                }
                TextField("Description", text: Binding(get: {description}, set: {description = String($0)}))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.greyBG)
                    .cornerRadius(7.5)
                Spacer()
            }
            .foregroundColor(.mainText)
            .padding()
            .onChange(of: store.copiedData, initial: false) {
                if store.copiedData.amount != 0.0 {
                    amount = store.copiedData.amountString
                    description = store.copiedData.description
                    date = store.copiedData.date
                }
            }
            .onAppear {
                if isEditMode {
                    amount = String(oldFlow!.amount)
                    date = oldFlow!.date
                    description = oldFlow!.description
                }
            }
        }
        .overlay {
            isDatePickerOpen ? CustomCalendarView(selectedDate: $date, isDatePickerOpen: $isDatePickerOpen)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * (isEditMode ? 0.2 : 0))
            : nil
        }
    }
    
    private func addFlow() async {
        let newFlow: Flow = Flow(amount: Double(amount) ?? 0.00, date: date, description: description)
        Task {
            try await store.writeNewFlow(flow: newFlow)
        }
        amount = ""
        date = Date()
        description = ""
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
        if amount.isEmpty { return "Add" }
        if isEditMode { return "Confirm" }
        if (Double(amount) != nil) {
            return Double(amount)! > 0 ? "Add Income" : "Add Expense"
        }
        return ""
    }
}


#Preview {
    AddNewFlow(store: FlowStore(), isEditMode: true, oldFlow: Flow(amount: 10.00, description: "Old flow"), isEditSheetOpen: .constant(false), editedFlow: .constant(Flow(amount: 0.00)))
        .background(.mainBG)
}

