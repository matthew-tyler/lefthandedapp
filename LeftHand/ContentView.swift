/*
	ContentView.swift
*/
import SwiftUI
import PencilKit

struct ContentView: View
	{
	@State var parent: LeftHandApp
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>

	let message =
		[
		"Horizontal, Small Grip, Right Hand",
		"Horizontal, Small Grip, Left Hand",
		"Horizontal, Large Grip, Right Hand",
		"Horizontal, Large Grip, Left Hand",
		"Vertical, Small Grip, Right Hand",
		"Vertical, Small Grip, Left Hand",
		"Vertical, Large Grip, Right Hand",
		"Vertical, Large Grip, Left Hand",
		]
		
	@State var current_message : Int = 0
	@State private var canvasView = PKCanvasView()

	init(_ parent: LeftHandApp)
		{
		_parent = State(initialValue: parent)
		}

	var body: some View
		{
		ZStack
			{
			MyCanvas(canvasView: $canvasView)
			VStack
				{
				HStack
					{
					Spacer().frame(width: 50)
					Text(message[current_message])
					Spacer()
					Button("Clear")
						{
						canvasView.drawing = PKDrawing()
						}
						.padding()
						.foregroundColor(.white)
						.background(Color.blue.opacity(0.5))
						.clipShape(RoundedRectangle(cornerRadius: 5))
					Button("Save")
						{
//						let instance = Writing(context: moc)
//						instance.id = UUID()
//						instance.type = "X" + message[current_message]
//						instance.data = canvasView.drawing.dataRepresentation()
//						try? moc.save()

						parent.person.scribbes[current_message] = Drawing(description: message[current_message], path: canvasView.drawing)
						current_message = (current_message + 1) % message.count

						if current_message == 0
							{
							parent.coordinator.screen = Screen.order
							}
						}
						.padding()
						.foregroundColor(.white)
						.background(Color.blue.opacity(0.5))
						.clipShape(RoundedRectangle(cornerRadius: 5))

					Button("Back...")
						{
						parent.coordinator.screen = Screen.demographics
						}
						.padding()
						.foregroundColor(.white)
						.background(Color.blue.opacity(0.5))
						.clipShape(RoundedRectangle(cornerRadius: 5))

					Spacer().frame(width: 50)
					}.background(Color.white.opacity(0.5))
				Spacer().frame(width: 50)
				}
			}
		}
	}
