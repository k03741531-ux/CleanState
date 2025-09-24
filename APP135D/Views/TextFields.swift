import SwiftUI
struct MainTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState var focused
    var isMultiline: Bool = false
    var minHeight: CGFloat = 96
    
    var body: some View {
        TextField("", text: $text, axis: isMultiline ? .vertical : .horizontal)
            .font(.poppins(.regular, size: 16))
            .foregroundStyle(.white)
            .focused($focused)
            .frame(
                minHeight: isMultiline ? minHeight : 56,
                alignment: isMultiline ? .topLeading : .leading
            )
            .padding(isMultiline ? 16 : 0)
            .padding(.horizontal, isMultiline ? 0 : 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("3D454C"))
                    .overlay(alignment: isMultiline ? .topLeading : .leading) {
                        Text(placeholder)
                            .font(.poppins(.regular, size: 16))
                            .foreground("ADAEBC")
                            .padding(isMultiline ? 16 : 0)
                            .padding(.horizontal, isMultiline ? 0 : 16)
                            .opacity(text.isEmpty ? 1 : 0)
                    }
            }
            .simultaneousGesture(TapGesture().onEnded({ _ in
                focused = true
            }))
    }
}

extension View {
    func addDoneButtonToKeyboard() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.hideKeyboard()
                }
            }
        }
    }
    
    func removeAutosuggestion() -> some View {
        self
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
    }
}

extension UIApplication {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MainTextField(
        placeholder: "Placeholder",
        text: .constant(""),
        isMultiline: false
    )
}
