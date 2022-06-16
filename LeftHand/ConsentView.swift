/*
	ConsentView.swift
*/

import Foundation
import SwiftUI
import PencilKit

struct ConsentView: View
	{
	@State var parent: LeftHandApp
	init(_ parent: LeftHandApp)
		{
		_parent = State(initialValue: parent)
		}

    var body: some View
		{
		VStack
			{
			Text("Something")
			Button("Start...")
				{
				parent.coordinator.screen = Screen.demographics
				parent.person.id = UUID()
				}
			}
		}
	}

