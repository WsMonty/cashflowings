//
//  FlowDetailView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 01.08.24.
//

import SwiftUI

struct FlowDetailView: View {
    var flow: Flow
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBG
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(flow.dateString)")
                        }
                        HStack {
                            Image(systemName: "dollarsign.square")
                            Text("\(flow.amountString)")
                        }
                        HStack {
                            if flow.descriptionEmoji.isEmpty { Image(systemName: "info.square")} else {
                                Text(flow.descriptionEmoji) }
                            Text("\(flow.description.isEmpty ? "No description" : flow.description)")
                        }
                    }
                .foregroundColor(.mainText)
            }
        }
    }
}

#Preview {
    FlowDetailView(flow: Flow(amount: 100.00, description: "Concert"))
}
