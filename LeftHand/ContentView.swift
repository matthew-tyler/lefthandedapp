/*
	ContentView.swift

	// https://www.hackingwithswift.com/books/ios-swiftui/how-to-combine-core-data-and-swiftui
*/

import SwiftUI
import PencilKit

struct ContentView: View
	{
	@Environment(\.undoManager) private var undoManager

	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
	
	@State private var canvasView = PKCanvasView()

	var body: some View
		{
		VStack
			{
			List(writing)
				{ instance in
				Text(instance.type ?? "Unknown")
				}
			HStack(spacing: 10)
				{
				Button("Clear")
					{
					canvasView.drawing = PKDrawing()
					}
				Button("Undo")
					{
					undoManager?.undo()
					}
				Button("Redo")
					{
					undoManager?.redo()
					}
				Button("Show")
					{
					let drawing = canvasView.drawing
					for stroke in drawing.strokes
						{
						print("\n\n\n\nCOORDINATES\n\n\n\n")
						stroke.path.forEach
							{ (point) in
							let newPoint = PKStrokePoint(location: point.location,
							timeOffset: point.timeOffset,
							size: point.size,
							opacity: point.opacity,
							force: point.force,
							azimuth: point.azimuth,
							altitude: point.altitude)
							print(newPoint)
							}
						}
					}
				}
			MyCanvas(canvasView: $canvasView)
			}
		}
	}

struct ContentView_Previews: PreviewProvider
	{
	static var previews: some View
		{
		ContentView()
		}
	}
