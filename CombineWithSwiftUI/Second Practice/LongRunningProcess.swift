//
//  LongRunningProcess.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/1/1404 AP.
//

import SwiftUI
import Combine

struct LongRunningProcessView: View {
    @StateObject private var viewModel = LongRunningProcessViewModel()
    var body: some View {
        VStack {
            Button("Start Long Running Process") {

            }.padding()

            Button("Refresh Data") {
                viewModel.refreshData()
            }.foregroundStyle(.red).padding()

            Button("Finished Process") {
                viewModel.cancel()
            }.opacity(viewModel.status == "Processing..." ? 1 : 0).padding()
            Spacer()

            Text(viewModel.status)
            Spacer()
        }
    }
}

final class LongRunningProcessViewModel: ObservableObject {

    @Published var data = "Start Data"
    @Published var status = ""
    private var cancellable: AnyCancellable?

    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
            status = "Processing..."
                print("VALUE ===>", value)
            return value
            }
            .delay(for: 5, scheduler: RunLoop.main)
            .sink(receiveValue: { [unowned self] value in
                print("SELF ==>", self)
            status = "Finished process"
            })
    }

    func refreshData() {
        data = "Refreshed Data"
    }

    func cancel() {
        status = "Cancelled"
        cancellable?.cancel()
    }
}

#Preview {
    LongRunningProcessView()
}
