/*
	ContentView.swift

	// https://www.hackingwithswift.com/books/ios-swiftui/how-to-combine-core-data-and-swiftui
*/

import SwiftUI
import PencilKit

struct ContentView: View
	{
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
	
	@State private var canvasView = PKCanvasView()
	@State var sequence : Int = 0

	var body: some View
		{
		VStack
			{
			List(writing)
				{ instance in
				Button
					{
					try? canvasView.drawing = PKDrawing(data: instance.data!)
					}
				label:
					{
					Text(instance.type ?? "Unknown")
					}
				}
			HStack(spacing: 10)
				{
				Button("Clear")
					{
					canvasView.drawing = PKDrawing()
					}
				Button("Save")
					{
					let actions = Writing(context: moc)
					actions.id = UUID()
					actions.type = "Saved " + (sequence as NSNumber).stringValue
					sequence = sequence + 1
					actions.data = canvasView.drawing.dataRepresentation()
					try? moc.save()
					}
				}
			MyCanvas(canvasView: $canvasView)
			}
		}
	}

