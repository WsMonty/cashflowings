//
//  HomeToolbar.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 16.08.24.
//

import SwiftUI

struct HomeToolbar: View {
    @ObservedObject var store: FlowStore
    @Binding var isSearchOpen: Bool
    @Binding var isDatePickerOpen: Bool
    @Binding var isDateFilterActive: Bool
    @Binding var isSettingsOpen: Bool
    @Binding var isListPickerOpen: Bool
    @Binding var isConfirmationDialogOpen: Bool
    @Binding var listNameToDelete: String
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: { isSearchOpen = !isSearchOpen }) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                if isSearchOpen { Searchbar(isDatePickerOpen: $isDatePickerOpen, store: store, isDateFilterActive: $isDateFilterActive) } else {
                    ListFilter(store: store, isListPickerOpen: $isListPickerOpen)
                }
                Spacer()
                
                Button(action: { isSettingsOpen = true }) {
                    Image(systemName: "gear")
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width - 20)
        }
        .foregroundColor(.mainText)
    }
}

#Preview {
    HomeToolbar(store: FlowStore(), isSearchOpen: .constant(false), isDatePickerOpen: .constant(false), isDateFilterActive: .constant(false), isSettingsOpen: .constant(false), isListPickerOpen: .constant(false), isConfirmationDialogOpen: .constant(false), listNameToDelete: .constant(""))
        .background(.mainBG)
}
