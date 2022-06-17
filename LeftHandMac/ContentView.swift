/*
	ContentView.swift
*/
import SwiftUI
import PencilKit

struct ContentView: View
	{
	@FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
	@Environment(\.managedObjectContext) var moc

	@State var drawing : PKDrawing = PKDrawing()
	@State var pen_path : Writing = Writing()

	var body: some View
		{
		ZStack
			{
			Color.white.ignoresSafeArea()

			VStack
				{
				Spacer()
				HStack
					{
					Button("Delete")
						{
						moc.delete(pen_path)
						try? moc.save()
						}
					Spacer().frame(width: 50)
					Button("Export")
						{
						for stroke in drawing.strokes
							{
							print("\n\n\n\nCOORDINATES\n\n\n\n")
							stroke.path.forEach
								{ point in
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
				Divider()
				HStack
					{
					List(writing)
						{ instance in
						Text(instance.type ?? "Unknown").onTapGesture
							{
							do
								{
								pen_path = instance
								drawing = try PKDrawing(data: pen_path.data!)
								}
							catch
								{
								print(error)
								}
							}
						}
					Spacer().frame(width: 10)
					Divider()
					Image(nsImage: drawing.image(from: drawing.bounds, scale: 1))
					Spacer()
					}
				}
			}
		}
	}
