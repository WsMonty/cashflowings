//
//  AddNewFlow.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

private struct initalData {
    static var amount: String = ""
    static var date: Date = Date()
    static var description: String = ""
}

struct AddNewFlow: View {
    @ObservedObject var store: FlowStore
    @State var amount: String = initalData.amount
    @State var date: Date = initalData.date
    @State var description: String = initalData.description
    var isEditMode: Bool
    var oldFlow: Flow?
    @Binding var isEditSheetOpen: Bool
    @Binding var editedFlow: Flow
    @State private var isDatePickerOpen: Bool = false
    @State private var isEditing: Bool = false
    var isIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    NewFlowButton(buttonText: getButtonText(), backgroundColor: getBackgroundColor(isClearButton: false), amount: amount, action: addNewFlow, disabled: amount.isEmpty || amount == "-" )
                    Spacer()
                    NewFlowButton(buttonText: "clear", backgroundColor: getBackgroundColor(isClearButton: true), amount: amount, action: clearForm, disabled: amount.isEmpty && description.isEmpty && date == Date())
                        .padding(.trailing, 5)
                }
                .padding(.bottom, 5)
                HStack {
                    HStack {
                        Text("Amount")
                        TextField("0.00", text: $amount, onEditingChanged: { _ in isEditing = true })
                            .onChange(of: amount, validateInput)
                            .keyboardType(.numbersAndPunctuation)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .background(.greyBG)
                            .cornerRadius(GlobalValues.cornerRadius)
                    }
                    .frame(width: UIScreen.main.bounds.width * (isIpad && isEditMode ? 0.45 : 0.57))
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
                TextField("Description", text: Binding(get: {description}, set: {description = String($0)}), onEditingChanged: { _ in isEditing = true })
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.greyBG)
                    .cornerRadius(GlobalValues.cornerRadius)
                
                Spacer()
            }
            .foregroundColor(.mainText)
            .padding(isIpad && isEditMode ? 80 : 15)
            .padding(.top, isEditMode ? 75 : 0)
            .frame(width: getModalWidth(),height: getModalHeight())
            .background(.mainBG)
            .onChange(of: store.copiedData, initial: false) {
                if store.copiedData.amount != 0.00 {
                    amount = store.locale.identifier == availableLocales[1].identifier ? store.copiedData.amountStringWithComma : store.copiedData.amountString
                    description = store.copiedData.description
                    date = store.copiedData.date
                }
            }
            .onAppear {
                if isEditMode {
                    amount = store.locale.identifier == availableLocales[1].identifier ? oldFlow!.amountStringWithComma : oldFlow!.amountString
                    date = oldFlow!.date
                    description = oldFlow!.description
                }
            }
        }
        .overlay {
            isDatePickerOpen ? CustomCalendarView(selected: $date, isDatePickerOpen: $isDatePickerOpen)
                .position(x: UIScreen.main.bounds.width / 2 - (isIpad && isEditMode ? 50 : 0), y: UIScreen.main.bounds.height * (isEditMode ? 0.3 : 0))
            : nil
        }
    }
    
    private func addNewFlow() {
        amount = amount.replacingOccurrences(of: ",", with: ".")
        Task {
            if isEditMode {
                try await store.editFlow(oldFlow: oldFlow!, newFlow: Flow(amount: Double(amount) ?? 0.00, date: date, description: description))
                editedFlow = Flow(amount: Double(amount) ?? 0.00, date: date, description: description)
                isEditSheetOpen = false
                return
            }
            let newFlow: Flow = Flow(amount: Double(amount) ?? 0.00, date: date, description: description)
            Task {
                try await store.writeNewFlow(flow: newFlow)
            }
            if !isEditMode {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            clearForm()
            isEditing = false
        }
    }
    
    private func clearForm() {
        amount = initalData.amount
        description = initalData.description
        date = initalData.date
        
        isEditing = false
        if !isEditMode {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func getModalWidth() -> CGFloat {
        if isIpad && isEditMode {
            return UIScreen.main.bounds.width * 0.75
        }
        
        return UIScreen.main.bounds.width
    }
    
    private func getModalHeight() -> CGFloat {
        if isIpad && isEditMode {
            return UIScreen.main.bounds.height * 0.8
        }
        if isEditMode {
            return isEditing ?  UIScreen.main.bounds.height - 275 : UIScreen.main.bounds.height
        }
        
        return isEditing ? 250 : 200
    }
    
    private func validateInput() {
        let filtered = amount.filter { "0123456789.-,".contains($0) }
        var result = filtered
        if filtered.contains(",") {
            let splitString = filtered.split(separator: ",")
            let beforeComma = String(splitString[0])
            let afterComma = splitString.count > 1 ? String(splitString[1].prefix(2)) : ""
            result = "\(beforeComma),\(afterComma)"
        }
        if filtered.contains(".") {
            let splitString = filtered.split(separator: ".")
            let beforeComma = String(splitString[0])
            let afterComma = splitString.count > 1 ? String(splitString[1].prefix(2)) : ""
            result = "\(beforeComma).\(afterComma)"
        }
        
        amount = result
    }
    
    private func getBackgroundColor(isClearButton: Bool) -> Color {
        if isClearButton {
            return .greyBG
        }
        let formattedAmount = amount.replacingOccurrences(of: ",", with: ".")
        if formattedAmount.isEmpty || formattedAmount == "-"  { return .greyBG }
        return Double(formattedAmount) ?? 0.00 >= 0 ? .income : .expense
    }
    
    private func getButtonText() -> LocalizedStringKey {
        let formattedAmount = amount.replacingOccurrences(of: ",", with: ".")
        if formattedAmount.isEmpty || formattedAmount == "-" { return "Add" }
        if isEditMode { return "Confirm" }
        if (Double(formattedAmount) != nil) {
            return Double(formattedAmount)! > 0 ? "Add Income" : "Add Expense"
        }
        return ""
    }
}

struct NewFlowButton: View {
    var buttonText: LocalizedStringKey
    var backgroundColor: Color
    var amount: String
    var action: ()->Void
    var disabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .padding(.horizontal, 15)
                .padding(.vertical, 7.5)
        }
        .disabled(disabled)
        .background(backgroundColor)
        .cornerRadius(GlobalValues.cornerRadius)
    }
    
    private func getBackgroundColor() -> Color {
        let formattedAmount = amount.replacingOccurrences(of: ",", with: ".")
        if formattedAmount.isEmpty || formattedAmount == "-"  { return .greyBG }
        return Double(formattedAmount) ?? 0.00 >= 0 ? .income : .expense
    }
}

#Preview {
    AddNewFlow(store: FlowStore(), isEditMode: true, oldFlow: Flow(amount: 10.00, description: "Old flow"), isEditSheetOpen: .constant(false), editedFlow: .constant(Flow(amount: 0.00)))
        .background(.mainBG)
}

