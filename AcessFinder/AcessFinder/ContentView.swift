//
//  ContentView.swift
//  AcessFinder
//
//  Created by Rafael Gonzaga on 22/04/24.
//

import SwiftUI
import ContactsUI

struct ContentView: View {
    
    enum PickerType: Identifiable{
        case photo, file, contact
        
        var id: Int {
            hashValue
        }
    }
    
    
    @State private var actionSheetVisible = false
    @State private var pickerType: PickerType?
    
    @State private var selectedType: PickerType?
    
    @State private var selectedImage: UIImage?
    @State private var selectedDocument:Data?
    @State private var selectedDocuemntName: String?
    @State private var selectiedContact: CNContact?
    
    var body: some View {
        VStack {
            VStack {
                if (self.selectedType == .photo   && self.selectedImage != nil){
                    Text("selectd image: s")
                    Image(uiImage: self.selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    
                }  else  if (self.selectedType == .file   && self.selectedDocument != nil){
                    Text("Document selected: " + self.selectedDocuemntName!)
                }
                else if (self.selectedType == .contact   && self.selectiedContact != nil){
                    Text("Contact card selected: " + self.selectiedContact!.givenName + " " + self.selectiedContact!.familyName)
                }
                
                
            }
            
            Button ("Pick a picker") {
                self.actionSheetVisible = true
            }
            .confirmationDialog("Selecty a type", isPresented: self.$actionSheetVisible) {
                Button("Photo"){
                    self.pickerType = .photo
                    self.selectedType = .photo
                }
                
                Button ("File"){
                    self.pickerType = .file
                    self.selectedType = .file
                }
                Button("Contact"){
                    self.pickerType = .contact
                    self.selectedType = .contact
                }
            }
        }
        .sheet(item: self.$pickerType, onDismiss: {print("dimiss")}){ item in
            switch item {
                case.photo :
                    ImagePicker(image: self.$selectedImage)
//                    NavigationView{
//                       Text("photo")
//                    }
                case .file:
                    FilePicker(file: self.$selectedDocument, fileName: self.$selectedDocuemntName)
                    
                case .contact:
                    ContactPicker(selectedContact: self.$selectiedContact)
            }
        }
      
    }
}

#Preview {
    ContentView()
}
