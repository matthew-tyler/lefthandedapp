/*
	ContentView.swift
*/

import SwiftUI
import PencilKit

struct ContentView: View
	{
	@Environment(\.undoManager) private var undoManager

	@State private var canvasView = PKCanvasView()

	var body: some View
		{
		VStack
			{
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
