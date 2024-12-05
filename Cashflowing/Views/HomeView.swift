//
//  HomeView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var store: FlowStore
    @State var isSettingsOpen: Bool = false
    @State var isSearchOpen: Bool = false
    @State var isDatePickerOpen: Bool = false
    @State var filteredDate: Date = Date()
    @State var isDateFilterActive: Bool = false
    
    @State var isListPickerOpen: Bool = false
    @State var isConfirmationDialogOpen: Bool = false
    @State var listNameToDelete: String = ""
    
    init(store: FlowStore) {
        self.store = store
        UIBarButtonItem.appearance().tintColor = .mainText
    }
    
    var body: some View {
        let flows: [Flow] = store.flows
        let currentList: String = UserDefaults.standard.string(forKey: "currentList") ?? "All"
        let combinedFilters: [(Flow)->Bool] = [{
            switch store.dataType {
            case .allFlows:
                $0.amount.isNormal
            case .income:
                $0.amount > 0
            case .expenses:
                $0.amount < 0
            }
        }, store.stringFilter, store.dateFilter, store.monthFilter, store.yearFilter, {
            if currentList == "All" { return true }
            
            return $0.listName == currentList
        }]
        
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.mainBG
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismissKeyboard()
                        }
                    VStack(spacing: 0) {
                        TotalAmount(flows: flows.filter { flow in
                            combinedFilters.allSatisfy { filter in
                                filter(flow)
                            }
                        }, locale: store.locale)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                        FlowsTableView(store: store, flows: flows.filter { flow in
                            combinedFilters.allSatisfy { filter in
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
                        HomeToolbar(store: store, isSearchOpen: $isSearchOpen, isDatePickerOpen: $isDatePickerOpen, isDateFilterActive: $isDateFilterActive, isSettingsOpen: $isSettingsOpen, isListPickerOpen: $isListPickerOpen, isConfirmationDialogOpen: $isConfirmationDialogOpen, listNameToDelete: $listNameToDelete)
                            .zIndex(1)
                    }
                }
                .overlay {
                    if isListPickerOpen {
                        ZStack {
                            Color.black.opacity(0.3)
                                .contentShape(Rectangle())
                                .ignoresSafeArea()
                                .onTapGesture {
                                    isListPickerOpen = false
                                }
                            ListPickerModal(store: store, isListPickerOpen: $isListPickerOpen, isConfirmationDialogOpen: $isConfirmationDialogOpen, listNameToDelete: $listNameToDelete)
                                .position(x: UIScreen.main.bounds.width / 2, y: 75)
                        }
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
            if isDatePickerOpen {
                ZStack {
                    Color.black.opacity(0.3)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            isDatePickerOpen = false
                        }
                    CustomCalendarView(selected: $filteredDate, isDatePickerOpen: $isDatePickerOpen)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.23)
                    .zIndex(1)
                }
            }
        }
        .onChange(of: filteredDate) {
            store.filterFlowsByDate(filter: filteredDate)
            isDateFilterActive = true
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    HomeView(store: FlowStore())
}
