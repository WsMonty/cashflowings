//
//  MonthYearFilter.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 15.08.24.
//

import SwiftUI

private let currentYear: Int = Calendar.current.component(.year, from: Date())

struct MonthYearFilter: View {
    @ObservedObject var store: FlowStore
    @State var selectedMonth: Month = .initial
    @State var selectedYear: Int = 0
    @State var isYearSelected: Bool = false
    @State var isMonthSelected: Bool = false
    
    var yearRange: [Int] {
        get {
            Array(currentYear - 5...currentYear)
        }
    }
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Menu {
                ForEach(yearRange, id: \.self) {year in
                    Button(action: {
                        selectedYear = year
                        isYearSelected = true
                    }) {
                        Text("\(String(year))")
                    }
                }
            } label: {
                isYearSelected
                ? Text(String(selectedYear))
                    .foregroundStyle(.income)
                : Text(LocalizedStringKey("Year"))
                    .foregroundStyle(.mainText)
            }
            .frame(width: 50)
            .padding(.leading, 10)
            .onChange(of: selectedYear, initial: false) {
                store.filterFlowsByYear(year: selectedYear)
            }
            
            Menu {
                ForEach(Month.allCases.filter { $0 != .initial }) {month in
                    Button(action: {
                        selectedMonth = month
                        isMonthSelected = true
                    }) {
                        Text(getMonthName(month: month))
                    }
                }
            } label: {
                isMonthSelected
                ? Text(getMonthName(month: selectedMonth))
                    .foregroundStyle(.income)
                : Text("Month")
                    .foregroundStyle(.mainText)
            }
            .frame(width: 100)
            .onChange(of: selectedMonth, initial: false) {
                store.filterFlowsByMonth(month: selectedMonth.value)
            }
            Spacer()
            Button(action: {
                selectedYear = 0
                selectedMonth = .initial
                store.removeAllFilters()
                isYearSelected = false
                isMonthSelected = false
            }) {
                Text("removeFilters")
                    .padding(.trailing, 15)
                    .foregroundStyle(.mainText)
            }
            .padding(10)
        }
        .background(.greyBG)
        .cornerRadius(GlobalValues.cornerRadius)
        .padding(5)
        .font(.system(size: 15))
    }
}

enum Month: Int, CaseIterable, Identifiable {
    case initial = -1
    case wholeYear = 0
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
    
    var id: Int { self.rawValue }
    var value: Int {
        return self.rawValue
    }
}

private func getMonthName(month: Month) -> LocalizedStringKey {
    switch month {
        
    case .wholeYear:
        return "whole"
    case .january:
        return "January"
    case .february:
        return "February"
    case .march:
        return "March"
    case .april:
        return "April"
    case .may:
        return "May"
    case .june:
        return "June"
    case .july:
        return "July"
    case .august:
        return "August"
    case .september:
        return "September"
    case .october:
        return "October"
    case .november:
        return "November"
    case .december:
        return "December"
    case .initial:
        return "initial"
    }
}

#Preview {
    MonthYearFilter(store: FlowStore())
}
