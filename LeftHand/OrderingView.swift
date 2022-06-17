/*
	OrderingView.swift
*/

import Foundation
import SwiftUI
import UIKit
import PencilKit

struct OrderingView: View
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
			HStack
				{
				Button("Done")
					{
					for scribble in parent.person.scribbes
						{
						print(scribble.description)
						}
					}
				}
			List
				{
				ForEach (parent.person.scribbes)
					{ scribble in
					Image(uiImage: getImage(path:scribble.path)).resizable().frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.height / 10)
					}
					.onMove(perform: move)
				}
				.environment(\.editMode, Binding.constant(EditMode.active))
			}
		}

	func move(from source: IndexSet, to destination: Int)
		{
		parent.person.scribbes.move(fromOffsets: source, toOffset: destination)
		}

	func getImage(path : PKDrawing) -> UIImage
		{
		let img = path.image(from: path.bounds, scale: 1)
		let screenSize: CGRect = UIScreen.main.bounds
		let size = CGSize(width: screenSize.width, height: screenSize.height)

		UIGraphicsBeginImageContext(size)
		let areaSize = CGRect(x: 0, y: 0, width: path.bounds.width, height: path.bounds.height)
		img.draw(in: areaSize)
		let final = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		return final
		}
	}

