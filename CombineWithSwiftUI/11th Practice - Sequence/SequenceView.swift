//
//  SequenceView.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/27/25.
//

import SwiftUI
import Combine

struct SequenceView: View {
    
    @StateObject private var viewModel = SequenceViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            Button("fetch list") {
                viewModel.fetch()
            }
        }
    }
}

final class SequenceViewModel: ObservableObject {
    
    @Published var dataToView = [String]()
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
       var dataIn = ["reza", "ali", "hamid"]
        dataIn.publisher
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { [unowned self] item in
                if dataToView.contains(item) { return }
                self.dataToView.append(item)
                print(item)
            })
            .store(in: &cancellables) // in this line pipeline finished and no more value will goes to pipeline after this line
        dataIn.append(contentsOf: ["1", "2", "3"])
    }
}

#Preview {
    SequenceView()
}
