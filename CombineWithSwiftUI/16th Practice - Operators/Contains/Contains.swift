//
//  Contains.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/20/1404 AP.
//

import SwiftUI
import Combine


struct ContainsExample2: View {
    @StateObject var vm = ContainsExampleViewModel2()
    var body: some View {
        VStack {
            Text(vm.description)
            Toggle("heating", isOn: $vm.heating)
            Toggle("air condition", isOn: $vm.airConditioning)
            Toggle("bathroom", isOn: $vm.bathroom)
            Toggle("basement", isOn: $vm.basement)
        }.padding()
            .onAppear {
                vm.fetch()
            }
    }
}

final class ContainsExampleViewModel2: ObservableObject {

    @Published var heating: Bool = false
    @Published var airConditioning: Bool = false
    @Published var basement: Bool = false
    @Published var bathroom: Bool = false
    @Published var description: String = ""
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String] = ["heating", "basement", "airconditioning", "bathroom"]
        cancellable = dataIn.publisher
            .prefix(2)
            .sink { [unowned self] string in
                description += string + "\n"
            }
        dataIn.publisher
            .contains("heating")
            .assign(to: &$heating)
        dataIn.publisher
            .contains("airconditioning")
            .assign(to: &$airConditioning)
        dataIn.publisher
            .contains("basement")
            .assign(to: &$basement)
        dataIn.publisher
            .contains("bathroom")
            .assign(to: &$bathroom)
    }
}


#Preview {
    ContainsExample2()
}
