//
//  TryMinByExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct Country: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var continent: String
    var shouldShowInList: Bool
    var placement: Int
}

struct TryMinByExample: View {
    @StateObject var vm = TryMinByViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.listOfCountries) { country in
                    HStack {
                        Text(country.name)
                        Spacer()
                        Text("\(country.placement)")
                    }
                }
            }.listStyle(PlainListStyle())
            HStack {
                Text("Min Placement Country:")
                Spacer()
                Text("\(vm.minCountry?.name ?? "Not Found")")
            }.padding()
        }
        .alert(item: $vm.minErrorAlert, content: { error in
            Alert(title: Text(error.title), message: Text(error.description))
        })
        .onAppear {
            vm.fetch()
        }
    }
}

final class TryMinByViewModel: ObservableObject {

    struct ErrorAlert: Error, Identifiable {
        var id = UUID()
        var title: String
        var description: String
    }

    @Published var listOfCountries: [Country] = []
    @Published var minCountry: Country?
    @Published var minAlert: Bool = false
    @Published var minErrorAlert: ErrorAlert?
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [Country] = [
            Country(name: "Albania", continent: "Europe", shouldShowInList: true, placement: 1),
            Country(name: "Afghanistan", continent: "Asia", shouldShowInList: true, placement: 2),
            Country(name: "United States", continent: "America", shouldShowInList: false, placement: 3)
        ]
        listOfCountries = dataIn

      cancellable = dataIn.publisher
            .tryMin { current, next in
                if !current.shouldShowInList {
                    throw ErrorAlert(title: "Error", description: "Cannot compare countries that are not shown in the list")
                }
                return current.placement < next.placement
            }.sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    minAlert = true
                    minErrorAlert = error as? ErrorAlert
                }
            } receiveValue: { [unowned self] country in
                minCountry = country
            }
    }
}

#Preview {
    TryMinByExample()
}
