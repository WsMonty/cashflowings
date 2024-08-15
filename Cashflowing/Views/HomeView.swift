//
//  HomeView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var store: FlowStore
    @State var flows: [Flow] = []
    @State var isSettingsOpen: Bool = false
    @State var isSearchOpen: Bool = false
    @State var isDatePickerOpen: Bool = false
    @State var filteredDate: Date = Date()
    @State var isDateFilterActive: Bool = false
    
    init(store: FlowStore) {
        self.store = store
        UIBarButtonItem.appearance().tintColor = .mainText
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.mainBG
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismissKeyboard()
                        }
                    VStack(spacing: 0) {
                        TotalAmount(flows: flows.filter {
                            switch store.dataType {
                            case .allFlows:
                                $0.amount.isNormal
                            case .income:
                                $0.amount > 0
                            case .expenses:
                                $0.amount < 0
                            }
                        }.filter { flow in
                            [store.stringFilter, store.dateFilter, store.monthFilter, store.yearFilter].allSatisfy { filter in
                                    filter(flow)
                            }
                        }, locale: store.locale)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                        FlowsTableView(store: store, flows: flows.filter {
                            switch store.dataType {
                            case .allFlows:
                                $0.amount.isNormal
                            case .income:
                                $0.amount > 0
                            case .expenses:
                                $0.amount < 0
                            }
                        }.filter { flow in
                            [store.stringFilter, store.dateFilter, store.monthFilter, store.yearFilter].allSatisfy { filter in
                                    filter(flow)
                            }
                        })
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        Divider()
                        AddNewFlow(store: store, isEditMode: false, isEditSheetOpen: .constant(false), editedFlow: .constant(Flow(amount: 0.00)))
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .toolbar {
                        HStack {
                            Button(action: { isSearchOpen = !isSearchOpen }) {
                                Image(systemName: "magnifyingglass")
                            }
                            
                            if isSearchOpen { Searchbar(isDatePickerOpen: $isDatePickerOpen, store: store, isDateFilterActive: $isDateFilterActive) }
                            Spacer()
                            Button(action: { isSettingsOpen = true }) {
                                Image(systemName: "gear")
                            }
                            .foregroundColor(.mainText)
                        }
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }
                }
            }
            .sheet(isPresented: $isSettingsOpen) {
                SettingsView(store: store, isSettingsOpen: $isSettingsOpen)
            }
        }
        .environment(\.locale, store.locale)
        .background(.mainBG)
        .foregroundColor(.mainText)
        .overlay {
            isDatePickerOpen ? CustomCalendarView(selected: $filteredDate, isDatePickerOpen: $isDatePickerOpen)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.23)
                .zIndex(1)
            : nil
        }
        .onChange(of: filteredDate) {
            store.filterFlowsByDate(filter: filteredDate)
            isDateFilterActive = true
        }
        .onChange(of: store.flows) {
            flows = store.flows
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    HomeView(store: FlowStore())
}
