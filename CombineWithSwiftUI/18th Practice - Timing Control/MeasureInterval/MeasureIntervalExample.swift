//
//  MeasureIntervalExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/5/1404 AP.
//

import Combine
import SwiftUI

struct MeasureIntervalExample: View {
    @StateObject var vm = MeasureIntervalExampleViewModel()
    @State var ready: Bool = false
    var body: some View {
        VStack {
            Button("Start") {
                vm.buttonTapPublisher.send()
                ready = true
            }

            Button {
                vm.buttonTapPublisher.send()
                ready = false
                vm.speed = nil
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(ready ? Color.green : Color.secondary)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .textCase(.uppercase)
            }

        }
    }
}

final class MeasureIntervalExampleViewModel: ObservableObject {

    var buttonTapPublisher = PassthroughSubject<Void, Never>()
    var speed: TimeInterval?
    var cancellable: AnyCancellable?

    init() {
       cancellable = buttonTapPublisher
            .measureInterval(using: RunLoop.main)
            .sink { stride in
                self.speed = stride.timeInterval
            }
    }
}

#Preview {
    MeasureIntervalExample()
}
