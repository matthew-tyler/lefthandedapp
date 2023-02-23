//
//  CalibrationView.swift
//  LeftHand
//
//  Created by Matt Tyler on 10/02/23.
//
import CoreMotion
import SwiftUI

class MotionDetector: ObservableObject {

    private let motionManager = CMMotionManager()

    private var timer = Timer()

    private var updateInterval: TimeInterval

    @Published var yaw: Double = 0
    @Published var adjustedYaw: Double = 0

    var deviceOrientation: Double {
        switch UIApplication.shared.statusBarOrientation {

        case .portrait:
            return 0.0
        case .landscapeLeft:
            return +90.0
        case .landscapeRight:
            return -90.0
        case .portraitUpsideDown:
            return 0.0
        default:
            return 0.0
        }
    }

    private var currentOrientation: UIDeviceOrientation = .landscapeLeft

    private var orientationObserver: NSObjectProtocol?

    let notification = UIDevice.orientationDidChangeNotification

    init(updateInterval: TimeInterval) {

        self.updateInterval = updateInterval
    }

    func start() {

        if motionManager.isDeviceMotionAvailable {

            motionManager.startDeviceMotionUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }

        } else {

            print("Motion data isn't available on this device.")
        }
    }

    func started() -> MotionDetector {
        start()
        return self
    }

    func updateMotionData() {
        if let data = motionManager.deviceMotion {
            yaw = data.attitude.yaw
            adjustedYaw = (yaw * 180 / Double.pi) + deviceOrientation
        }
    }

    func reset() {
        stop()
        start()
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
    }

    deinit {
        stop()
    }
}

struct CalibrationView: View {

    @EnvironmentObject var detector: MotionDetector

    @State var parent: LeftHandApp

    var adjustedYaw: String {
        return String(format: "%.2f", detector.adjustedYaw * -1)
    }

    var body: some View {
        VStack {
            Spacer()
            Text("Yaw: " + adjustedYaw)
                .font(.system(.body, design: .monospaced))
            Button("Set Reference") {
                detector.reset()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            Spacer()
            Button("Back") {
                parent.coordinator.screen = Screen.consent
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}
