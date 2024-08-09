//
//  EditFlowView.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 06.08.24.
//

import SwiftUI

struct EditFlowView: View {
    @ObservedObject var store: FlowStore
    var flow: Flow
    @Binding var isEditSheetOpen: Bool
    @Binding var editedFlow: Flow

    var body: some View {
        NavigationStack {
            AddNewFlow(store: store, isEditMode: true, oldFlow: flow, isEditSheetOpen: $isEditSheetOpen, editedFlow: $editedFlow)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { isEditSheetOpen = false }) {
                            Text("Cancel")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.mainText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.mainText, lineWidth: 1)
                        }
                    }
                }
                .background(.mainBG)
        }
    }
}


#Preview {
    EditFlowView(store: FlowStore(), flow: Flow(amount: 10.00, date: Date(), description: "Test"), isEditSheetOpen: .constant(true), editedFlow: .constant(Flow(amount: 0.00)))
}
