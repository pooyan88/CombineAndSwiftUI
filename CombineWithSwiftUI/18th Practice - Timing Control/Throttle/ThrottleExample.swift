//
//  ThrottleExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 5/29/25.
//

import SwiftUI
import Combine

struct ThrottleExample: View {
    @StateObject private var viewModel = ThrottleExampleViewModel()
    var body: some View {
        VStack {
            Slider(value: $viewModel.throttleTime, in: 0...5) {
                Text("Throttle Time")
            } minimumValueLabel: {
                Image(systemName: "hare")
            } maximumValueLabel: {
                Image(systemName: "tortoise")
            }
            .padding()
            
            HStack {
                Button("Start") {
                    viewModel.setupTimer()
                }
                Spacer()
                Button("Reset") {
                    viewModel.reset()
                }
            }.padding()
            
            List {
                ForEach(viewModel.dataToView, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

final class ThrottleExampleViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    @Published var throttleTime: Double = 2 
    var formatter = DateFormatter()
    var cancellable: AnyCancellable?
    
    init() {
        formatter.dateFormat = "HH:mm:ss"
        setupTimer()
    }
    
    func setupTimer() {
        cancellable?.cancel()
        cancellable = Timer.publish(every: throttleTime, on: .main, in: .common)
            .autoconnect()
            .throttle(for: .seconds(throttleTime), scheduler: RunLoop.main, latest: true)
            .map {  [weak self] date in
                self?.formatter.string(from: date) ?? ""
            }.sink { [weak self] newTimeString in
                guard let self = self else { return }
                self.dataToView.append(newTimeString)
            }
    }
    
    func reset() {
        cancellable?.cancel()
        dataToView = []
    }
}

#Preview {
    ThrottleExample()
}

