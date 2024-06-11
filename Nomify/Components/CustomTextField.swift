//
//  CustomTextField.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChange: (Bool) -> () = { _ in}
    var commit: () -> () = {}
    var isSecure: Bool
        
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            if isSecure {
                SecureField("", text: $text, onCommit: commit)
                    .foregroundColor(.black)
                    .submitLabel(.done)
            }
            else {
                TextField("", text: $text, onEditingChanged: editingChange, onCommit: commit)
                    .foregroundColor(.black)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
            }
        }
    }
    
}
