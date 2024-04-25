//
//  DocumentPicker.swift
//  AcessFinder
//
//  Created by Rafael Gonzaga on 22/04/24.
//

import Foundation
import SwiftUI
import UIKit

struct FilePicker: UIViewControllerRepresentable {
    
    @Binding var file: Data?
    @Binding var fileName: String?
    
    func makeCoordinator() -> FilePicker.Coordinator {
        return FilePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FilePicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: FilePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<FilePicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: FilePicker
        
        init(parent1: FilePicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
           print("[FilePicker] didPickDocumentAt")
            guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            DispatchQueue.main.async {
                url.stopAccessingSecurityScopedResource()
                print("[FilePicker]] stopAccesingSecurityResource done")
            }
            do {
                let document = try Data(contentsOf: url.absoluteURL)
                self.parent.file = document
                self.parent.fileName = url.lastPathComponent
            }
            catch {
                print("[FilePicker]] Error selecting file: " + error.localizedDescription)
            }
        }
    }
}
