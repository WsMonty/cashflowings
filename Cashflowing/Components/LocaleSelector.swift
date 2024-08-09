//
//  LocaleSelector.swift
//  Cashflowing
//
//  Created by Gilles Grethen on 08.08.24.
//

import SwiftUI

struct LocaleSelector: View {
    @ObservedObject var store: FlowStore
    @State private var selectedLocale: Locale = .current
    @State private var isLocaleModuleOpen: Bool = false
    
    var body: some View {
        StyledButton(isSheetOpen: $isLocaleModuleOpen, action: { isLocaleModuleOpen = true }, buttonText: "changeLocale")
        .confirmationDialog("localeDialogTitle", isPresented: $isLocaleModuleOpen) {
            ForEach(availableLocales) {localeOption in
                Button( action: { store.changeLocale(locale: localeOption.locale)} ) {
                    Text("\(localeOption.displayName)")
                }
            }
        }
    }
}

#Preview {
    LocaleSelector(store: FlowStore())
}
