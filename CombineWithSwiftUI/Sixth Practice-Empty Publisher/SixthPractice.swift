//
//  SixthPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/2/1404 AP.
//

import SwiftUI
import Combine

struct SixthPractice: View {

    @StateObject private var viewModel = SixthPracticeViewModel()
    var body: some View {
        VStack {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
        }.onAppear {
            viewModel.fetch()
        }
    }
}


final class SixthPracticeViewModel: ObservableObject {

    enum MyError: Error {
        case bombDetected
    }

    @Published var dataToView = [String]()
    var cancellables: Set<AnyCancellable> = []

   func fetch() {
       let dataIn = ["Value 1", "Value 2", "Value 3", "🧨", "Value 5", "Value 6"]

       dataIn.publisher
           .tryMap { item in  // can throw error and use for error handling
               if item == "🧨" {
                   throw MyError.bombDetected
               }
               return item
           }
           .catch { error in
               Empty(completeImmediately: true)
           }
           .sink { [unowned self] value in
               dataToView.append(value)
           }.store(in: &cancellables)
    }
}

#Preview {
    SixthPractice()
}
