//
//  ListPickerModal.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 16.08.24.
//

import SwiftUI

struct ListPickerModal: View {
    @ObservedObject var store: FlowStore
    @Binding var isListPickerOpen: Bool
    @Binding var isConfirmationDialogOpen: Bool
    @Binding var listNameToDelete: String
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(Array(store.listNames.sorted().enumerated()), id: \.element) { index, list in
                HStack {
                    Button(action: {
                        Task {
                            do{ try await store.filterFlowsByList(listName: list); isListPickerOpen = false } catch {print("Failed to filter Lists")}}}) {
                                Text(list)
                            }
                    Spacer()
                    Button(action: { listNameToDelete = list; isConfirmationDialogOpen = true }) {
                        Image(systemName: "minus.square.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .font(.title3)
                    
                }
                if index != store.listNames.count - 1 { Divider().background(.mainText) }
            }
        }
        .zIndex(1)
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .tint(.mainText)
        .background(.mainBG)
        .cornerRadius(GlobalValues.cornerRadius)
        .confirmationDialog("Do you want to delete the list \"\(listNameToDelete)\"?", isPresented: $isConfirmationDialogOpen, titleVisibility: .visible) {
            Button("deleteList", role: .destructive) {
               // TODO
                isConfirmationDialogOpen = false
                listNameToDelete = ""
            }
            Button("cancel", role: .cancel) {
                isConfirmationDialogOpen = false
                listNameToDelete = ""
            }
        }
    }
}

#Preview {
    ListPickerModal(store: FlowStore(), isListPickerOpen: .constant(false), isConfirmationDialogOpen: .constant(false), listNameToDelete: .constant(""))
}
