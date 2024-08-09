//
//  FlowDetailView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 01.08.24.
//

import SwiftUI

struct FlowDetailView: View {
    @ObservedObject var store: FlowStore
    var flow: Flow
    @State var isEditSheetOpen = false
    @State var editedFlow: Flow = Flow(amount: 10.0)
    @State var usedFlow: Flow = Flow(amount: 10.00)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.mainBG)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 5)
                    .fill(usedFlow.amount > 0 ? .income : .expense)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width)
                    .opacity(0.9)
                    .shadow(color: .gray, radius: 1)
                VStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(usedFlow.dateString)")
                        }
                        HStack {
                            Image(systemName: "dollarsign.square")
                            Text("\(usedFlow.amountString)")
                        }
                        HStack {
                            if usedFlow.descriptionEmoji.isEmpty { Image(systemName: "info.square")} else {
                                Text(usedFlow.descriptionEmoji) }
                            Text("\(usedFlow.description.isEmpty ? "No description" : usedFlow.description)")
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                    Button(action: { isEditSheetOpen = true }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("edit")
                        }
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    }
                    .sheet(isPresented: $isEditSheetOpen) {
                        EditFlowView(store: store, flow: flow, isEditSheetOpen: $isEditSheetOpen, editedFlow: editedFlow)
                    }
                }
            }
        }
        .onAppear {
            usedFlow = flow
        }
        .onChange(of: editedFlow) {
            usedFlow = editedFlow
        }
    }
}

#Preview {
    FlowDetailView(store: FlowStore(), flow: Flow(amount: 100.00, description: "Long description"))
}
