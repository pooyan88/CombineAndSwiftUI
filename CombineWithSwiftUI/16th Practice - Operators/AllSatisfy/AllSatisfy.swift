//
//  AllSatisfy.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/19/1404 AP.
//

import SwiftUI
import Combine

struct AllSatisfy: View {

    @StateObject var viewModel = AllSatisfyViewModel()
    @State var number: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Add a number", text: $number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)
                Button("+") {
                    viewModel.addNumber(number: number)
                }
            }.padding()
            Button("Check") {
                viewModel.checkFibonacci()
            }
            List(viewModel.numbers, id: \.self) { number in
                Text("\(number)")
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.result != .none },
                set: { newValue in
                    if !newValue {
                        viewModel.result = .none // reset after dismissing alert
                    }
                }
            )) {
                switch viewModel.result {
                case .success:
                    return Alert(title: Text("✅ All are Fibonacci numbers!"))
                case .failure:
                    return Alert(title: Text("❌ Not all are Fibonacci numbers."))
                case .none:
                    return Alert(title: Text("")) // fallback, won't be shown
                }
            }

        }
    }
}


final class AllSatisfyViewModel: ObservableObject {

    enum Result {
        case success
        case failure
        case none
    }

    @Published var numbers: [Int] = []
    @Published var result: Result = .none
    var cancellable: AnyCancellable?

    func checkFibonacci() {
        let fibonacciNumbersTo144 = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]
        cancellable = numbers.publisher
            .allSatisfy { number in
                fibonacciNumbersTo144.contains(number)
            }.sink { [unowned self] isSuccess in
                result = isSuccess ? .success : .failure
            }
    }

    func addNumber(number: String) {
        guard !number.isEmpty else { return }
        numbers.append(Int(number) ?? 0)
    }
}

#Preview {
    AllSatisfy()
}
