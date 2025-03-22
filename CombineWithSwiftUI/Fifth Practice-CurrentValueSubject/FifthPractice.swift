//
//  FifthPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/2/1404 AP.
//

import SwiftUI
import Combine

struct FifthPractice: View {

    @StateObject var viewModel = FifthPracticeViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {

            Button("Lorenzo") {
                viewModel.selection = "Lorenzo"
            }

            Button("Ellen") {
                viewModel.selection = "Ellen"
            }

            Text(viewModel.selection)
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
        }
    }
}

final class FifthPracticeViewModel: ObservableObject {

    @Published var selection = "Nothing Here"
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    var cancellable = Set<AnyCancellable>()

    init() {
        $selection
            .map { [unowned self] value -> Bool in
                if value == selection {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }.store(in: &cancellable)
    }

}

#Preview {
    FifthPractice()
}
