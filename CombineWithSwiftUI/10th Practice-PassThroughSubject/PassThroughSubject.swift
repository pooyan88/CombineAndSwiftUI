//
//  PassThroughSubject.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/26/25.
//

import SwiftUI
import Combine

struct PassThroughSubjectView: View {
    
    @StateObject var viewModel = PassThroughSubjectViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter the card number", text: $viewModel.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)
                Group {
                    switch viewModel.state {
                    case .ok:
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    case .invalid:
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                    case .notEvaluated:
                        EmptyView()
                    }
                }
            }.padding()
            Button("validate card") {
                viewModel.textSubject.send(viewModel.text)
            }
        }
    }
}

final class PassThroughSubjectViewModel: ObservableObject {
    
    enum ValidationState {
        case ok
        case invalid
        case notEvaluated
    }
    
    @Published var text = "Enter the card number here"
    @Published var state: ValidationState = .notEvaluated
    var textSubject = PassthroughSubject<String, Never>()
    
    init() {
        textSubject
            .map { [unowned self] newValue in
                validateCard(cardNumber: newValue)
            }.assign(to: &$state)
    }
    
    private func validateCard(cardNumber: String) -> ValidationState {
        guard getPureCardNumber(cardNumber: cardNumber).isNumber else { return .invalid }
        guard getPureCardNumber(cardNumber: cardNumber).count == 16 else { return .invalid }
        guard getPureCardNumber(cardNumber: cardNumber).hasPrefix("6219") else { return .invalid }
        return .ok
        
    }
    
    private func getPureCardNumber(cardNumber: String) -> String {
        if cardNumber.contains("*") {
            return cardNumber.replacing("*", with: "")
        } else if cardNumber.contains(" ") {
            return cardNumber.replacing(" ", with: "")
        }
        return cardNumber
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

#Preview {
    PassThroughSubjectView()
}
