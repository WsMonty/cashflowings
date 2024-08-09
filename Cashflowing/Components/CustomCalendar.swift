//
//  CustomCalendar.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 08.08.24.
//

import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isDatePickerOpen: Bool
    
    let calendar = Calendar.current
    let dateFormatter: DateFormatter
    let monthFormatter: DateFormatter
    
    init(selectedDate: Binding<Date>, isDatePickerOpen: Binding<Bool>) {
        self._selectedDate = selectedDate
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "d"
        
        self.monthFormatter = DateFormatter()
        self.monthFormatter.dateFormat = "MMMM yyyy"
        self._isDatePickerOpen = isDatePickerOpen
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    moveMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                Spacer()
                Text(monthFormatter.string(from: selectedDate))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    moveMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
            }
            
            let days = generateDaysInMonth(for: selectedDate)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    Text(day > 0 ? "\(day)" : "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                        .background(day == calendar.component(.day, from: selectedDate) ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(day > 0 ? .white : .clear)
                        .onTapGesture {
                            if day > 0 {
                                selectDay(day)
                            }
                        }
                }
            }
            Button(action: {
                withAnimation {
                    isDatePickerOpen = false
                }
            }) {
                Text("Done")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(GlobalValues.cornerRadius)
            }
            .padding(.vertical, 10)
        }
        .transition(.opacity)
        .zIndex(3)
        .font(.system(size: 13))
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.4)
        .background(.lighterBG)
        .cornerRadius(GlobalValues.cornerRadius)
    }
    
    private func generateDaysInMonth(for date: Date) -> [Int] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstDay = calendar.date(byAdding: .day, value: -calendar.component(.day, from: monthInterval.start) + 1, to: monthInterval.start) else {
            return []
        }
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let firstWeekday = calendar.component(.weekday, from: monthFirstDay)
        let offsetDays = Array(repeating: 0, count: firstWeekday - 1)
        let days = (1...numDays).map { $0 }
        
        return offsetDays + days
    }
    
    private func moveMonth(by value: Int) {
        guard let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) else { return }
        selectedDate = newDate
    }
    
    private func selectDay(_ day: Int) {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let newDate = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) else { return }
        selectedDate = newDate
    }
}

#Preview {
    CustomCalendarView(selectedDate: .constant(Date()), isDatePickerOpen: .constant(true))
}
