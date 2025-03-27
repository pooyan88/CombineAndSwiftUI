//
//  TimerPublisherView.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/27/25.
//

import SwiftUI
import Combine

struct Timer_Intro: View {
    @StateObject var vm = TimerPublisherViewModel4()
    var body: some View {
        VStack(spacing: 20) {
            Text("Adjust Interval")
            
            HStack {
                Button("connect") {
                    vm.start()
                }
                Spacer()
                Button("stop") {
                    vm.stop()
                }
            }.padding()
            List(vm.data, id: \.self) { item in
                Text(item)
            }
        }
        .font(.title)
    }
}

final class TimerPublisherViewModel4: ObservableObject {
    
    @Published var data: [String] = []
    var timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    var timerCancellable: Cancellable?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        timerPublisher
            .sink { [unowned self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = "ss"
                data.append(String(formatter.string(from: date)))
            }.store(in: &cancellables)
    }
    
    func start() {
        timerCancellable  = timerPublisher.connect()
    }
    
    func stop() {
        timerCancellable?.cancel()
        data.removeAll()
    }
}

final class TimerPublisherViewModel3: ObservableObject {
    @Published var data: [String] = []
    var otpTimer = 10 {
        didSet {
            buttonTitle = otpTimer.description
            if otpTimer <= 0 {
                buttonTitle = "Start"
            }
        }
    }
    var buttonTitle = "Start"
    var cancellable: AnyCancellable?
    
    func start() {
        if otpTimer <= 0 {
            otpTimer = 10
            data.removeAll()
        }
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [unowned self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = "ss"
                if otpTimer >= 0 {
                    data.append(otpTimer.description)
                    otpTimer -= 1
                } else {
                    cancellable?.cancel()
                    data.removeAll()
                }
            }
    }
}


final class TimerPublisherViewModel2: ObservableObject {
    @Published var data: [String] = []
    @Published var interval: Double = 1.0
    private var timerCancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    let timeFormatter = DateFormatter()
    
    init() {
        timeFormatter.dateFormat = "HH:mm:ss"
        // Observe the interval and restart the timer when it changes
        $interval
            .dropFirst() // Drop the first value (to prevent triggering immediately on initialization)
            .sink { [unowned self] _ in
                // When the interval changes, cancel the current timer and restart it
                timerCancellable?.cancel()
                data.removeAll() // Clear the data array when the interval is updated
                start() // Restart the timer
            }
            .store(in: &cancellables) // Store the interval cancellable for cleanup
    }

    func start() {
        // Create a new timer for the given interval
        timerCancellable =
        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [unowned self] time in
                data.append(timeFormatter.string(from: time)) // Append the formatted time
            }
    }
}

final class TimerPublisherViewModel: ObservableObject {
    @Published var timers: [String] = []
    var startSecond = 12
    var cancellable: AnyCancellable?
    @Published var buttonTitle: String = "Tap" // Mark as @Published to observe the button title change

    func start() {
        timers = [] // Reset the array
        var remainingSeconds = startSecond // Countdown variable
        
        // Start the timer
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if remainingSeconds >= 0 {
                    let formattedTime = String(format: "00:%02d", remainingSeconds) // Format the time
                    self.timers.append(formattedTime) // Append to timers array
                    self.buttonTitle = formattedTime // Update button title

                    remainingSeconds -= 1 // Decrease countdown
                } else {
                    self.buttonTitle = "Done!" // Update button title when done
                    self.cancellable?.cancel() // Stop the timer when reaching 0
                }
            }
    }
}
#Preview {
    Timer_Intro()
}
