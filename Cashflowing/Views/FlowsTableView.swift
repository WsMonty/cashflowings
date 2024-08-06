//
//  FlowsTable.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI

struct FlowsTableView: View {
    @ObservedObject var store: FlowStore
   
    
    var body: some View {
        NavigationStack {
            List(store.flows, id: \.id) { flow in
                FlowTableRow(flow: flow, store: store)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    FlowsTableView(store: FlowStore())
        .background(.mainBG)
}

