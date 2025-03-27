//
//  NinthPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/3/1404 AP.
//

import SwiftUI
import Combine

// MARK: - Just Publisher

struct NinthPractice: View {

    @StateObject private var viewModel = NinthPracticeViewModel()

    var body: some View {
        VStack {
            Text("This Week winner is:")
            Text(viewModel.data)
                .bold()

            Form {
                Section(content: { Text("This Week winner is:") })
                List(viewModel.dataToView, id: \.self) { item in
                    Text(item)
                }
            }.border(Color.gray)

            Button("Next") {
                viewModel.fetch() // The Proof that Just is going only publish once, look at line 53
            }
            Spacer()
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

final class NinthPracticeViewModel: ObservableObject {
    @Published var data = ""
    @Published var dataToView = [String]()

    func fetch() {
        let dataIn = ["Julian", "Meredith", "Luan", "Daniel", "Marina"]
        _ = dataIn.publisher
            .sink(receiveValue: { [unowned self] value in
                if !dataToView.contains(value) {
                    dataToView.append(value)
                }
            })
        if !dataToView.isEmpty {
            Just(dataIn[0 + 1])
                .map { value in
                    value.uppercased()
            }.assign(to: &$data)
        }
    }
}

#Preview {
    NinthPractice()
}
