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
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>

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
				Spacer()
				Button("Done")
					{
					/*
						Write the user details
					*/
					let instance = Person(context: moc)
					instance.id = parent.person.id
					instance.sex = parent.person.sex
					instance.age = parent.person.age
					instance.handedness = parent.person.handedness
					instance.writinghand = parent.person.writingHand
					instance.qualifications = parent.person.educationLevel
					try? moc.save()

					/*
						Write the pen motions
					*/
					for scribble in parent.person.scribbes
						{
//						print(scribble.description)
						let instance = Writing(context: moc)
						instance.id = UUID()
						instance.type = scribble.description
						instance.data = scribble.path.dataRepresentation()
						instance.person_id = parent.person.id
						try? moc.save()
						}
					}
					.padding()
					.foregroundColor(.white)
					.background(Color.blue.opacity(0.5))
					.clipShape(RoundedRectangle(cornerRadius: 5))
				Spacer().frame(width: 50)
				}
			List
				{
				ForEach (parent.person.scribbes)
					{ scribble in
					Image(uiImage: getImage(path:scribble.path)).resizable().frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 5)
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
