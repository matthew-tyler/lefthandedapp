/*
 ConsentView.swift
 */

import Foundation
import SwiftUI

struct ConsentView: View {
    @State var parent: LeftHandApp

    init(_ parent: LeftHandApp) {
        _parent = State(initialValue: parent)
    }

    var body: some View {
        Spacer()

        Button {
            parent.coordinator.screen = Screen.calibration
        } label: {
            Image("OtagoLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
        }

        VStack {
            Text("University of Otago").font(.largeTitle)
            Text("Writing Experiment").font(.largeTitle)
        }
        Spacer()
        Text("Please press \"Start Experiment\" once you have signed the Consent Form").font(.title)
        Spacer()
        Button("Start Experiment") {
            parent.coordinator.screen = Screen.demographics
            parent.person.id = UUID()
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.blue.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        Spacer()
    }
}
