//
//  DocumentPicker.swift
//  Cashflow
//
//  Created by Gilles Grethen on 31.07.24.
//
import SwiftUI
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif
#if canImport(UIKit)
import UIKit
#endif

enum PickerMode {
    case importDocument
    case exportDocument
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    var parent: DocumentPickerView
    @ObservedObject var store: FlowStore
    @Binding var showDocumentPicker: Bool
    
    init(parent: DocumentPickerView,store: ObservedObject<FlowStore>, showDocumentPicker: Binding<Bool>) {
        self.parent = parent
        self._store = store
        self._showDocumentPicker = showDocumentPicker
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFileURL = urls.first else { return }
            
            switch parent.pickerMode {
            case .importDocument:
                copyFileToDocuments(fileURL: selectedFileURL)
            case .exportDocument:
               return
            }
        }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func copyFileToDocuments(fileURL: URL) {
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not find the Documents directory")
            return
        }
        
        let destinationURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: fileURL, to: destinationURL)
            Task {
                try await store.getFlows()
            }
            print("File successfully copied to: \(destinationURL.path)")
        } catch {
            print("Error copying file: \(error)")
        }
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {
    @ObservedObject var store: FlowStore
    @Binding var showDocumentPicker: Bool
    var pickerMode: PickerMode
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(parent: self, store: _store, showDocumentPicker: $showDocumentPicker)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        switch pickerMode {
        case .importDocument:
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = context.coordinator
            picker.allowsMultipleSelection = false
            picker.modalPresentationStyle = .formSheet
            return picker
        case .exportDocument:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy-HH:mm:ss"
            let currentDate = Date()
            let dateString = dateFormatter.string(from: currentDate)
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFileURL = tempDirectory.appendingPathComponent("CashflowData_\(dateString).csv")
            
            var csvString = ""
            for flow in store.flows {
                let line = "\(flow.dateString),\(flow.amountString),\(flow.description)\n"
                csvString.append(line)
            }
            do {
                try csvString.write(to: tempFileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to write temporary file: \(error)")
            }
            
            let picker = UIDocumentPickerViewController(forExporting: [tempFileURL], asCopy: true)
            picker.delegate = context.coordinator
            picker.allowsMultipleSelection = false
            picker.modalPresentationStyle = .formSheet
            return picker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No need to update the view controller in this case
    }
}



