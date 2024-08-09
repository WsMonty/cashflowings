//
//  formatDate.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 08.08.24.
//

import Foundation

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    
    return dateFormatter.string(from: date)
}
