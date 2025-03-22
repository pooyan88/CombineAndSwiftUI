//
//  Third Practice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/1/1404 AP.
//

import SwiftUI
import Combine

struct ThirdValidationPractive: View {

    @StateObject var viewModel = ThirdPracticeViewModel()

    var body: some View {
        VStack {
            Group {
                HStack {
                    TextField("Enter your name", text: $viewModel.name)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.gray)
                        )
                    Text(viewModel.nameValidation)
                }.padding()
                HStack {
                    TextField("Enter your name", text: $viewModel.lastName)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.gray)
                        )
                    Text(viewModel.lastNameValidation)
                }.padding()

                Button("Cancel All Validations") {
                    viewModel.cancel()
                }
            }
        }
    }
}

final class ThirdPracticeViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var lastName: String = ""
    @Published var nameValidation: String = ""
    @Published var lastNameValidation: String = ""
    var cancellable: Set<AnyCancellable> = []

    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅"
            }.sink { name in
                print("Name ===>", name)
                self.nameValidation = name

            }.store(in: &cancellable)

        $lastName.map { value -> String in
            value.isEmpty ? "❌" : "✅"
        }.sink { emoji in
            self.lastNameValidation = emoji
        }.store(in: &cancellable)
    }

    func cancel() {
        nameValidation = ""
        lastNameValidation = ""
        cancellable = []
    }
}


#Preview {
    ThirdValidationPractive()
}
