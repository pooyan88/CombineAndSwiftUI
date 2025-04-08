//
//  TryAllSatisfy.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/19/1404 AP.
//

import SwiftUI
import Combine

struct TryAllSatisfy: View {

    @StateObject var viewModel = TryAllSatisfyViewModel()
    @State var number: String = ""
    var body: some View {
        VStack {
            Text(viewModel.resultText)
                .padding()
            HStack {
                TextField("Enter a number < 145", text: $number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)
                Button("+") {
                    viewModel.add(number: number)
                }
            }.padding()
            List(viewModel.numbers, id: \.self) { number in
                Text("\(number)")
            }
            Button("Check") {
                viewModel.check()
            }
            .padding()
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text(error.header), message: Text(error.message))
                }
        }
    }
}

final class TryAllSatisfyViewModel: ObservableObject {

    struct ValidationError: Error, Identifiable {
        var id = UUID()
        var header: String
        var message: String
    }

    @Published var numbers: [Int] = []
    @Published var error: ValidationError?
    @Published var isAllFibonacci: Bool = false
    @Published var resultText: String = ""
    var cancellable: AnyCancellable?

    func check() {
        let fibonacciNumbersTo144 = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]
        cancellable = numbers.publisher
            .tryAllSatisfy { number in
                guard number <= 144 else { throw ValidationError(header: "Error", message: "the number is not valid") }
                return fibonacciNumbersTo144.contains(number)
            }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error as? ValidationError
                }
            } receiveValue: { result in
                self.isAllFibonacci = result
                self.resultText = result ? "All numbers are Fibonacci numbers" : "Not all numbers are Fibonacci numbers"
            }

    }

    func add(number: String) {
        guard !number.isEmpty else { return }
        numbers.append(Int(number) ?? 0)
    }
}

#Preview {
    TryAllSatisfy()
}
