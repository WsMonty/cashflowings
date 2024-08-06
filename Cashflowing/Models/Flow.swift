//
//  Flow.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import Foundation

struct Flow: Identifiable, Codable, Hashable {
    let id: UUID
    var type: FlowType {
        get {
            amount > 0 ? .income : .expense
        }
    }
    var amount: Double
    var amountString: String {
        get {
            String(format: "%.2f", amount) + " €"
        }
    }
    let date: Date
    var dateString: String {
        get {
            formatDate(date: date)
        }
    }
    let description: String
    var descriptionEmoji: String {
        get {
            getDescriptionEmoji(description: description.lowercased())
        }
    }
    
    
    
    
    init(id: UUID = UUID(), amount: Double, date: Date = Date(), description: String = "") {
        self.id = id
        self.amount = amount
        self.date = date
        self.description = description
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    func formatDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.date(from: date)!
    }
    
    func getDescriptionEmoji(description: String) -> String {
        if description.contains("concert") {
            return "🎶"
        }
        if description.contains("train") || description.contains("travel") || description.contains("plane") || description.contains("car") {
            return "🚃"
        }
        if description.contains("plane") || description.contains("car") {
            return "✈️"
        }
        if description.contains("car") || description.contains("auto") {
            return "🚗"
        }
        if description.contains("restaurant") || description.contains("food") || description.contains("drinks") || description.contains("eating") {
            return "🍕"
        }
        
        return ""
    }
}

enum FlowType: String, Codable {
    case income
    case expense
}

extension Flow {
    static let sampleData: [Flow] = [
        Flow(amount: 426.25, date: Date("15.05.2024")),
        Flow(amount: 100.00, date: Date("21.03.2024"), description: "Concert"),
        Flow(amount: 250.00, date: Date("22.03.2024"), description: "Concert"),
        Flow(amount: -35.50, date: Date("12.04.2024")),
        Flow(amount: -23.55, date: Date("25.07.2024")),
        Flow(amount: -100.00, date: Date("11.04.2024"), description: "Train ticket"),
    ].sorted(by: { $0.date < $1.date })
}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
