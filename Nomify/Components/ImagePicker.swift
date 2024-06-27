//
//  ImagePicker.swift
//  Nomify
//
//  Created by Andy Vu on 6/26/24.
//

import SwiftUI
import UIKit

extension Data {
    var base64: String {
        self.base64EncodedString()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Data
    @Binding var show: Bool
    
    var sourceType: UIImagePickerController.SourceType
    
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Leave empty
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.8)
            self.parent.selectedImage = data!
            self.parent.show.toggle()
        }
    }
    
}

