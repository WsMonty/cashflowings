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

@MainActor
class FlowStore: ObservableObject {
    @Published var flows: [Flow] = []
    
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
                
                if let dateString = separatedValues.first,
                   let date = dateFormatter.date(from: String(dateString)),
                   let amount = Double(String(separatedValues[1]).replacingOccurrences(of: "€", with: "").trimmingCharacters(in: .whitespaces)) {
                    let description = separatedValues.count > 2 ? String(separatedValues[2]) : ""
                    let flow = Flow(amount: amount, date: date, description: description)
                    loadedFlows.append(flow)
                }
            }
            
            self.flows = loadedFlows
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
}

