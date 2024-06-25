import SwiftUI

// MARK: SEARCHBAR STRUCT
struct SearchBar: View {
        
    @Binding var text: String
    @State var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.footnote)
            
            CustomTextField(placeholder: Text(placeholder).foregroundColor(.gray), text: $text, isSecure: false)
                
            
            if text != "" {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.footnote)
                        .foregroundStyle(Color("themeGreen"))
                })
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
