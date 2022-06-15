/*
	ContentView.swift
*/

import SwiftUI
import PencilKit

struct ContentView: View
	{
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
	@State var pkDrawing : PKDrawing = PKDrawing()

	var body: some View
		{
		VStack
			{
			Button
				{
				for stroke in pkDrawing.strokes
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
				label:
					{
					Text("Export")
					}
			HStack
				{
				List(writing)
					{ instance in
					Button
						{
						do
							{
							pkDrawing = try PKDrawing(data: instance.data!)
							}
						catch
							{
							print(error)
							}
						}
						label:
							{
							Text(instance.type ?? "Unknown")
							}
					}
				Image(nsImage: pkDrawing.image(from: pkDrawing.bounds, scale: 1))
				}
			}
		}
	}
