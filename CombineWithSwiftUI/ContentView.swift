//
//  ContentView.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/1/1404 AP.
//

import SwiftUI
import Combine

// MARK: - Training two way binding, learned @StateObject, ObservableObject

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            VStack {
                TextField("State", text: $viewModel.state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Text(viewModel.state)
            }
            .padding()
        }
    }
}

final class ViewModel: ObservableObject {

    @Published var state = "Begin State"

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state = "Second State"
        }
    }
}


final class PublishedValidationViewModel: ObservableObject {

    @Published var name = ""
    @Published var message: String = ""
    private var cancellable: AnyCancellable?

    init() {
        cancellable = $name
            .map {
                print("name property is now: \(self.name)")
                print("Value received is: \($0)")
                return $0.isEmpty ? "❌" : "✅"
            }
            .sink { [unowned self] value in
                self.message = value
            }
    }
}

struct PublishedValidation: View {

    @StateObject private var viewModel = PublishedValidationViewModel()
    @State var message = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)

                Text(viewModel.message)
                Spacer()
            }
            .padding()
            Button("Cancel the pipeline") {
                viewModel.name = ""
            }
        }
    }
}

struct PublishedValidation2: View {

    @StateObject private var viewModel = PublishedValidationViewModel()
    @State var message: String = ""

    var body: some View {

        HStack {
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.gray)
                .cornerRadius(.pi)
                .onChange(of: viewModel.name) { newValue in
                    message = newValue.isEmpty ? "❌" : "✅"
                }
            Spacer()
            Text(message)
        }
        .padding()
    }
}

#Preview {
    PublishedValidation()
}
