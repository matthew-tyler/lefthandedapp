/*
	OrderingView.swift
*/

import Foundation
import SwiftUI

struct OrderingView: View
	{
	@State var parent: LeftHandApp
	@State private var isEditable = false

	init(_ parent: LeftHandApp)
		{
		_parent = State(initialValue: parent)
		}

    var body: some View
		{
		List
			{
			ForEach (parent.person.scribbes)
				{ scribble in
				Text(scribble.description)
				}
				.onMove(perform: move)
				.onLongPressGesture
					{
					withAnimation
						{
						self.isEditable = true
						}
					}

			}
			.environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
		}

	func move(from source: IndexSet, to destination: Int)
		{
		parent.person.scribbes.move(fromOffsets: source, toOffset: destination)
		withAnimation
			{
			isEditable = false
			}
		}
	}

