//
//  ContactPicker.swift
//  AcessFinder
//
//  Created by Rafael Gonzaga on 22/04/24.
//

import SwiftUI
import Contacts
import Combine
import Foundation
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = EmbeddedContactPickerViewController
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedContact: CNContact?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, EmbeddedContactPickerViewControllerDelegate {
    
        let parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }
        
        func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contact: CNContact) {
            parent.selectedContact = contact
            viewController.dismiss(animated: true, completion: nil)
            
        }

        func embeddedContactPickerViewControllerDidCancel(_ viewController: EmbeddedContactPickerViewController) {
            print("Cancelled")
        }
    }

    

    func makeUIViewController(context: UIViewControllerRepresentableContext<ContactPicker>) -> ContactPicker.UIViewControllerType {
        let result = ContactPicker.UIViewControllerType()
        result.delegate = context.coordinator
        return result
    }

    func updateUIViewController(_ uiViewController: ContactPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ContactPicker>) { }

}

protocol EmbeddedContactPickerViewControllerDelegate: class {
    func embeddedContactPickerViewControllerDidCancel(_ viewController: EmbeddedContactPickerViewController)
    func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contact: CNContact)
}

class EmbeddedContactPickerViewController: UIViewController, CNContactPickerDelegate {
    weak var delegate: EmbeddedContactPickerViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.open(animated: animated)
    }
    
    private func open(animated: Bool) {
        let viewController = CNContactPickerViewController()
        viewController.delegate = self
        self.present(viewController, animated: false)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: false) {
            self.delegate?.embeddedContactPickerViewControllerDidCancel(self)
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.dismiss(animated: false) {
            self.delegate?.embeddedContactPickerViewController(self, didSelect: contact)
        }
    }
}
