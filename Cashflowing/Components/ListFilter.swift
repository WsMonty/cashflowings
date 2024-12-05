//
//  ListFilter.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 16.08.24.
//

import SwiftUI

struct ListFilter: View {
    @ObservedObject var store: FlowStore
    @Binding var isListPickerOpen: Bool
    @State var listNameToDelete: String = ""
    @State var isConfirmationDialogOpen: Bool = false
    
    
    var body: some View {
        let currentList = UserDefaults.standard.string(forKey: "currentList")
        
        ZStack {
            Button(action: { isListPickerOpen = !isListPickerOpen }) {
                HStack {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text(currentList ?? "All")
                }
            }
            .onAppear {
                store.getListNames()
            }
            Spacer()
        }
    }
}

#Preview {
    ListFilter(store: FlowStore(), isListPickerOpen: .constant(false))
}

