//
//  AddNewList.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 16.08.24.
//

import SwiftUI

struct AddNewList: View {
    @ObservedObject var store: FlowStore
    @State var isEntryOpen: Bool = false
    @State var newListName: String = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        HStack {
            StyledButton(isSheetOpen: $isEntryOpen, action: { isEntryOpen = !isEntryOpen; focusedField = .newListEntry }, buttonText: "addList")
            if isEntryOpen {
                HStack {
                    TextField("listName", text: $newListName)
                        .focused($focusedField, equals: .newListEntry)
                        .padding(8)
                        .background(.greyBG)
                        .tint(.mainText)
                        .cornerRadius(GlobalValues.cornerRadius)
                    
                    Button(action: {
                        Task {
                            do {
                                try await store.addNewList(listName: newListName)
                                isEntryOpen = false
                                newListName = ""
                            } catch {
                                print("Failed to add new list: \(error)")
                            }
                        }
                    }) {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                    }
                    Button(action: { isEntryOpen = false; newListName = "" }) {
                        Image(systemName: "clear")
                            .font(.title2)
                    }
                }
            }
            Spacer()
        }
        .foregroundStyle(.mainText)
        .frame(width: .infinity, height: 50)
    }
}

#Preview {
    AddNewList(store: FlowStore())
        .background(.mainBG)
}
