//
//  DelayForExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 5/22/25.
//

import SwiftUI
import Combine

struct DelayForExample: View {
    @StateObject var vm = DelayForExampleViewModel()
    var body: some View {
        VStack {
            Text("Delay For")
            Picker(selection: $vm.delaySecond, label: Text("Delay time")) {
                Text("0").tag(0)
                Text("1").tag(1)
                Text("2").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            Button("Fetch data") {
                vm.fetch2()
            }
            List {
                ForEach(vm.dataToView, id: \.self) {
                    Text($0)
                }
            }
            if vm.isFetching {
                ProgressView()
            } else {
                Text(vm.data)
            }
            Spacer()
        }
    }
}

final class DelayForExampleViewModel: ObservableObject {
    @Published var data = ""
    @Published var dataToView: [String] = []
    var delaySecond = 1
    @Published var isFetching = false
    var cancellable: AnyCancellable?
    
    func fetch() {
        isFetching = true
        let dataIn = ["Value1", "Value2", "Value3"]
        cancellable = dataIn.publisher
            .delay(for: .seconds(delaySecond), scheduler: RunLoop.main)
            .sink { [unowned self] completion in
                isFetching = false
            } receiveValue: { [unowned self] incommingData in
                data = incommingData
            }
    }
    
    func fetch2() {
        let dataIn = ["Value1", "Value2", "Value3"]
        cancellable = dataIn.publisher
            .delay(for: .seconds(delaySecond), scheduler: RunLoop.main)
            .sink { [unowned self] data in
                if !dataToView.contains(data) {
                    dataToView.append(data)
                } else {
                    dataToView = []
                }
            }
    }
}

#Preview {
    DelayForExample()
}
