//
//  MyCanvas.swift
//  LeftHand
//
//  Created by andrew on 3/06/22.
//

import Foundation
import SwiftUI
import PencilKit

struct MyCanvas: UIViewRepresentable
	{
	@Binding var canvasView: PKCanvasView

	func makeUIView(context: Context) -> PKCanvasView
		{
		canvasView.drawingPolicy = .anyInput
		canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
		return canvasView
		}

	func updateUIView(_ canvasView: PKCanvasView, context: Context)
		{
		/* Nothing */
		}
	}
