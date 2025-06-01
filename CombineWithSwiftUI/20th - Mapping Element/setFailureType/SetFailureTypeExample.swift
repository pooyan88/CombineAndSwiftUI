//
//  SetFailureTypeExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct SetFailureTypeExample: View {
    @StateObject var vm = SetFailureTypeExampleViewModel(isError: true)
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { item in
                    Text(item)
                }
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.description))
        }
    }
}

final class SetFailureTypeExampleViewModel: ObservableObject {

    struct MyError: Identifiable, Error, CustomStringConvertible {
        var title = "Error"
        var description = "Error Description"
        var id = UUID()
    }
    @Published var dataToView: [String] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?
    var isError: Bool

    init(isError: Bool) {
        self.isError = isError

       cancellable = getPipeline(isError: isError)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error as? MyError
                }
            } receiveValue: { item in
                self.dataToView.append(item)
            }

    }

    func getPipeline(isError: Bool) -> AnyPublisher<String, Error> {
        let dataIn: [String] = ["Result 1", "Result 2", "Result 3", "Invalid Data", "Result 4"]
        if isError {
           return dataIn.publisher
                .tryMap { item in
                    guard !item.contains("Invalid") else { throw MyError() }
                    return item
                }
                .eraseToAnyPublisher()
        } else {
          return dataIn.publisher
                .map { item in
                    if item.contains("Invalid") {
                        return "Not From Error Section"
                    }
                    return item
                }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

#Preview {
    SetFailureTypeExample()
}
