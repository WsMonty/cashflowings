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
            VStack {
                Button(action: {
                    pickerMode = .exportDocument
                    showDocumentPicker = true
                }) {
                    Text("Export CVS")
                }
                .padding(20)
                .background(.expense)
                .cornerRadius(10)
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(store: store, showDocumentPicker: $showDocumentPicker, pickerMode: pickerMode)
                }
                Text("Exports the currently used CVS with all the chash flows to a chosen folder.")
                    .font(.caption)
                    .padding(.vertical, 10)
                Divider()
                    .padding(.vertical, 10)
                Button(action: {
                    pickerMode = .importDocument
                    showDocumentPicker = true
                }) {
                    Text("Choose new file")
                }
                .padding(20)
                .background(.expense)
                .cornerRadius(10)
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPickerView(store: store, showDocumentPicker: $showDocumentPicker, pickerMode: pickerMode)
                    
                }
                VStack(alignment: .leading) {
                    Text("Choose a new CSV file to read and write new data.\n")
                    Text("Make sure that the file has maximum 3 columns filled and use no titles. So just 3 columns with as many rows as you wish. 1st column contains the date in format \"dd.MM.yyy\", 2nd column contains the price in format \"0.00 €\", and 3rd column contains an optional text description.\nRefer to this example CSV:\n")
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
        }
    }
        
}


#Preview {
    SettingsView(store: FlowStore(), isSettingsOpen: .constant(true))
}


