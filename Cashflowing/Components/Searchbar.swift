//
//  Searchbar.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 14.08.24.
//

import SwiftUI

struct Searchbar: View {
    @State var search: String = ""
    @Binding var isDatePickerOpen: Bool
    @ObservedObject var store: FlowStore
    @FocusState private var focusedField: FocusedField?
    @Binding var isDateFilterActive: Bool
    
    
    var body: some View {
        HStack {
            Button(action: { isDatePickerOpen = !isDatePickerOpen }) {
                Image(systemName: "calendar")
                    .foregroundStyle(isDateFilterActive ? .income : .mainText)
            }
            TextField("Search...", text: $search)
                .focused($focusedField, equals: .searchbar)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(.greyBG)
                .tint(.mainText)
                .cornerRadius(GlobalValues.cornerRadius)
                .frame(minWidth: UIScreen.main.bounds.width * 0.5)
                .onChange(of: search) {
                    store.filterFlows(filter: search.lowercased())
                }
                .onAppear {
                    focusedField = .searchbar
                }
            Button(action: {
                search = ""
                store.removeAllFilters()
                isDateFilterActive = false
            }) {
                Image(systemName: "trash")
            }
        }
        .foregroundStyle(.mainText)
    }
}

#Preview {
    Searchbar(isDatePickerOpen: .constant(false), store: FlowStore(), isDateFilterActive: .constant(false))
        .background(.mainBG)
}
