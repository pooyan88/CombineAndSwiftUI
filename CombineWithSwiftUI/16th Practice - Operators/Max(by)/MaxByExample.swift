//
//  MaxByExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/26/1404 AP.
//

import SwiftUI
import Combine

struct MaxByExample: View {
    @StateObject var vm = MaxByExampleViewModel()
    var body: some View {
        VStack {
            List(vm.persons, id: \.id) { person in
                HStack {
                    Text(person.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(person.city)
                }
            }
            Text("Max Value: \(vm.maxValue)")
        }.onAppear {
            vm.fetch()
        }
    }
}


final class MaxByExampleViewModel: ObservableObject {

    struct Profile: Identifiable {
        var id = UUID()
        var name: String
        var city: String
    }

    @Published var persons: [Profile] = []
    @Published var maxValue: String = ""
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn = [Profile(name: "Igor", city: "Moscow"),
        Profile(name: "Rebecca", city: "Atlanta"),
        Profile(name: "Christina", city: "Stuttgart"),
        Profile(name: "Lorenzo", city: "Rome"),
        Profile(name: "Oliver", city: "London")]
        persons = dataIn
        cancellable = dataIn.publisher
            .max(by: compareProfile(_:_:))
            .sink { profile in
                self.maxValue = profile.city
            }
    }

    func compareProfile(_ lhs: Profile, _ rhs: Profile) -> Bool {
        lhs.city < rhs.city
    }
}


#Preview {
    MaxByExample()
}
