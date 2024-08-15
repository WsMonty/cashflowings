//
//  FlowStore.swift
//  Cashflow
//
//  Created by Gilles Grethen on 30.07.24.
//

import Foundation
import UIKit
import MobileCoreServices
import SwiftUI

enum DataType {
    case allFlows
    case income
    case expenses
}

private var initalFilter: (Flow) -> Bool = { $0.amountString != "false" }

@MainActor
class FlowStore: ObservableObject {
    @Published var flows: [Flow] = Flow.sampleData
    @Published var copiedData: Flow = Flow(amount: 0)
    @Published var dataType: DataType = .allFlows
    @Published var locale: Locale = .current
    
    @Published var stringFilter: (Flow) -> Bool = initalFilter
    @Published var dateFilter: (Flow) -> Bool = initalFilter
    @Published var monthFilter: (Flow) -> Bool = initalFilter
    @Published var yearFilter: (Flow) -> Bool = initalFilter
    
    private static func getFileURL() throws -> URL {
        let fileManager = FileManager.default
        let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsURL.appendingPathComponent("Cashflow.csv")
        return fileURL
    }
    
    func getFlows() async throws {
        do {
            let fileURL = try Self.getFileURL()
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try "".write(to: fileURL, atomically: true, encoding: .utf8)
            }
            
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let decoded = content.replacingOccurrences(of: ";", with: "").split(whereSeparator: \.isNewline)
            
            var loadedFlows: [Flow] = []
            for string in decoded {
                let separatedValues = string.split(separator: ",")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let amountCharacterSet = "0123456789.-"
                let currencyCharacterSet =  "€$£"
                
                if let dateString = separatedValues.first,
                   let date = dateFormatter.date(from: String(dateString)),
                   let amount = Double(String(separatedValues[1]).filter { amountCharacterSet.contains($0) }) {
                    let description = separatedValues.count > 2 ? String(separatedValues[2]) : ""
                    let currencyString: String = String(separatedValues[1].filter { currencyCharacterSet.contains($0) })
                    let currency = currencyString.isEmpty ? GlobalValues.defaultCurrency : currencyString
                    let flow = Flow(amount: amount, currency: currency, date: date, description: description)
                    loadedFlows.append(flow)
                }
            }
            
            self.flows = loadedFlows.sorted(by: { $0.date < $1.date })
        } catch {
            print("Error loading or creating file: \(error)")
            throw error
        }
    }
    
    func writeNewFlow(flow: Flow) async throws {
        let flowString = "\(flow.dateString),\(flow.amountString),\(flow.description)"
        let fileURL = try Self.getFileURL()
        
        do {
            var fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            fileContent.append("\r\n\(flowString)")
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            
            try await self.getFlows()
        } catch {
            print("Error updating file: \(error)")
        }
    }
    
    func deleteFlow(flow: Flow) {
        if let index = flows.firstIndex(of: flow) {
            flows.remove(at: index)
        }
        do {
            try replaceCSVContent()
        } catch {
            print("Error replacing content of csv file. Reason: \(error)")
        }
    }
    
    func editFlow(oldFlow: Flow, newFlow: Flow) async throws {
        if oldFlow == newFlow {
            print("Flows were the same")
            return
        }
        if let index = flows.firstIndex(of: oldFlow) {
            flows.remove(at: index)
        }
        flows.append(newFlow)
        do {
            try replaceCSVContent()
            try await self.getFlows()
        } catch {
            print("Error replacing content of csv file. Reason: \(error)")
        }
    }
    
    func filterFlows(filter: String) {
        if filter.isEmpty {
            stringFilter = initalFilter
            return
        }
        
        stringFilter = { $0.description.lowercased().contains(filter) || $0.amountString.contains(filter) || $0.dateString.contains(filter) }
    }
    
    func filterFlowsByDate(filter: Date) {
        let formattedDate = formatDate(date: filter)
        
        dateFilter = { $0.dateString == formattedDate }
    }
    
    func filterFlowsByMonth(month: Int) {
        if month == -1 { return }
        if month == 0 {
            monthFilter = initalFilter
            return
        }
        monthFilter = { Calendar.current.component(.month, from: $0.date) == month }
    }
    
    func filterFlowsByYear(year: Int) {
        if (year == 0) { return }
        yearFilter = { Calendar.current.component(.year, from: $0.date) == year }
    }
    
    func removeAllFilters() {
        stringFilter = initalFilter
        dateFilter = initalFilter
        monthFilter = initalFilter
        yearFilter = initalFilter
       // flows = unfilteredFlows
    }
    
    private func replaceCSVContent() throws {
        let fileURL = try Self.getFileURL()
        
        var csvString = ""
        for flow in flows.sorted(by: { $0.date < $1.date }) {
            let line = "\(flow.dateString),\(flow.amountString),\(flow.description)\n"
            csvString.append(line)
        }
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error replacing content of csv file. Reason: \(error)")
        }
    }
    
    func changeLocale(locale: Locale) {
        UserDefaults.standard.set(locale.identifier, forKey: "selectedLocale")
        self.locale = locale
    }
    
    func loadSavedLocale() -> Locale {
        if let savedLocaleIdentifier = UserDefaults.standard.string(forKey: "selectedLocale") {
            return Locale(identifier: savedLocaleIdentifier)
        }
        return .current
    }
}

