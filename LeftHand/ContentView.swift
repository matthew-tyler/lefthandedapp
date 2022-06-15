/*
	ContentView.swift
*/
import SwiftUI
import PencilKit

struct ContentView: View
	{
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>

	let message = ["Left", "Right"]
	@State var current_message : Int = 0

	@State private var canvasView = PKCanvasView()

	var body: some View
		{
		VStack
			{
			Text(message[current_message])
			HStack(spacing: 10)
				{
				Button("Clear")
					{
					canvasView.drawing = PKDrawing()
					current_message = (current_message + 1) % message.count
					}
				Button("Save")
					{
					let actions = Writing(context: moc)
					actions.id = UUID()
					actions.type = message[current_message]
					actions.data = canvasView.drawing.dataRepresentation()
					try? moc.save()
					}
				}
			MyCanvas(canvasView: $canvasView)
			}
		}
	}

