//
//  SeventhPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/2/1404 AP.
//

import SwiftUI
import Combine

enum InvalidAgeError: String, Error, Identifiable {
    var id: String { rawValue }
    case overHundred = "Cannot be more than 100"
    case underZero =  "Cannot be less than zero"
}

struct SeventhPractice: View {

    @StateObject var viewModel = SeventhPracticeViewModel()
    @State var age = ""

    var body: some View {
        VStack {
            TextField("Hello", text: $age)
                .keyboardType(UIKeyboardType.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.gray)
            Button("Save") {
                viewModel.save(age: Int(age) ?? -1)
            }.padding()
            Text(viewModel.age.description)
        }.padding()
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Invalid Age"), message: Text(error.rawValue))
            }
    }
}

final class SeventhPracticeViewModel: ObservableObject {
    @Published var age = 0
    @Published var error: InvalidAgeError?
    var cancellable = Set<AnyCancellable>()

    func save(age: Int) {
        Validators.validAgePublisher(age: age)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { [unowned self] age in
                self.age = age
            }.store(in: &cancellable)

    }
}

final class Validators {

    static func validAgePublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.underZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.overHundred)
                .eraseToAnyPublisher()
        }
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
}

#Preview {
    SeventhPractice()
}
