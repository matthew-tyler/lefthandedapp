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
	@State var saveError : Bool = false
	@State var saveSuccess : Bool = false

	init(_ parent: LeftHandApp)
		{
		_parent = State(initialValue: parent)
		saveError = false
		saveSuccess = false
		}

    var body: some View
		{
        
		VStack
			{
 
			HStack
				{
				Spacer().frame(width: 50)
				Image("OtagoLogo")
					.resizable()
					.aspectRatio(contentMode: .fit)
                    .frame(width:50, height:83, alignment: .center)
				Text("Please order from most clear (top) to least clear (bottom).").font(.title)
				Spacer()
				Button("Done")
					{
					/*
						Write the pen motions
					*/
					for scribble in parent.person.scribbes
						{
						let instance = Writing(context: moc)
						instance.id = UUID()
						instance.type = scribble.description
						instance.data = scribble.path.dataRepresentation()
						instance.person_id = parent.person.id
						parent.person.authorRanking.append(instance.id!)
						}

                        
                   
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
					instance.authorranks = parent.person.authorRanking
					instance.latinsquareorder = parent.person.latinSquareOrder
					instance.date = Date()		// this is when the person finished, not when they started

					/*
						Push to the database
					*/
					do
						{
						try moc.save()
						saveSuccess = true
						saveError = false

						parent.person.rewind()
						}
					catch
						{
						saveSuccess = false
						saveError = true
						}
					}
					.padding()
					.foregroundColor(.white)
					.background(Color.blue.opacity(0.5))
					.clipShape(RoundedRectangle(cornerRadius: 5))
					.alert(isPresented: $saveError)
						{
						Alert(title: Text("Save Error!"), message: Text("Failed to save writing.  Please report this error"))
						}
					.alert(isPresented: $saveSuccess)
						{
						Alert(title: Text("Thank You"), message: Text("Thank you for participating in this study"), dismissButton: .default(Text("OK"), action: { parent.coordinator.screen = Screen.conset}))
						}
				Button("QUIT")
					{
					parent.person.rewind()
					parent.coordinator.screen = Screen.conset
					}
					.padding()
					.foregroundColor(.white)
					.background(Color.red.opacity(0.5))
					.clipShape(RoundedRectangle(cornerRadius: 5))

				Spacer().frame(width: 50)
				}.frame(height:100, alignment: .leading)
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
