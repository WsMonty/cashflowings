//
//  SettingsView.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var store: FlowStore
    @State private var showDocumentPicker = false
    @State private var pickerMode: PickerMode = .exportDocument
    @Binding var isSettingsOpen: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                LocaleSelector(store: store)
                Divider()
                    .padding(5)
                StyledButton(isSheetOpen: $showDocumentPicker, action: {
                    pickerMode = .exportDocument
                    showDocumentPicker = true
                }, buttonText: "exportCSV")
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(store: store, showDocumentPicker: $showDocumentPicker, pickerMode: pickerMode)
                }
                Text("exportCVSExplanation")
                    .font(.caption)
                    .padding(.vertical, 10)
    
                StyledButton(isSheetOpen: $showDocumentPicker, action: {
                    pickerMode = .importDocument
                    showDocumentPicker = true
                }, buttonText: "chooseNewFile")
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(store: store, showDocumentPicker: $showDocumentPicker, pickerMode: pickerMode)
                    
                }
                VStack(alignment: .leading) {
                    Text("chooseNewFileInfo1")
                    Text("chooseNewFileInfo2")
                    Image("CSV-example")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .font(.caption)
                .padding(.top, 20)
            }
            .foregroundColor(.mainText)
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { isSettingsOpen = false }) {
                        Text("Dismiss")
                    }
                    .foregroundColor(.mainText)
                }
            }
            .background(.mainBG)
        }
    }
    
}


#Preview {
    SettingsView(store: FlowStore(), isSettingsOpen: .constant(true))
}


