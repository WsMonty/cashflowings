//
//  Locales.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 08.08.24.
//

import SwiftUI

struct LocaleOption: Identifiable, Hashable {
    let id = UUID()
    let identifier: String
    let displayName: String

    var locale: Locale {
        Locale(identifier: identifier)
    }
}

let availableLocales: [LocaleOption] = [
    LocaleOption(identifier: "en_GB", displayName: "English"),
    LocaleOption(identifier: "de_DE", displayName: "Deutsch"),
]
