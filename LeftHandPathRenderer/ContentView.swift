/*
	ContentView.swift
*/

import SwiftUI
import PencilKit

class Parser
	{
	var document: [Character] = Array(String(""))
	var current: Int = 0

	init(document: String)
		{
		self.document = Array(document)
		current = 0
		}

	func isUsable(_ char: Character) -> Bool
		{
		if (char.isASCII)
			{
			return char.isNumber || char.isLetter || char == "."
			}
		return false
		}

	func getToken() -> String
		{
		if (current >= document.count)
			{
			return ""
			}
		while !isUsable(document[current])
			{
			current = current + 1
			if (current >= document.count)
				{
				return ""
				}
			}

		let start = current
		while isUsable(document[current])
			{
			current = current + 1
			if (current >= document.count)
				{
				break;
				}
			}

		let range = document.index(document.startIndex, offsetBy: start) ..< document.index(document.startIndex, offsetBy: current)
		return String(document[range])
		}
	}


struct ContentView: View
	{
	@State var picture: NSImage = NSImage()
	@State var parser = Parser(document: "")

	func loadImage(_ filename: URL?) -> NSImage
		{
		let image = NSImage()
		if filename == nil
			{
			return image
			}

		let contents = try! String(contentsOf: filename!, encoding: .utf8)

		var imageDescription: [PKStroke] = []
		var path: [PKStrokePoint] = []
		parser = Parser(document: contents)
		repeat
			{
			let token = parser.getToken()
			if (token == "")
				{
				break;
				}
			else if (token == "Stroke")
				{
				if (path.count != 0)
					{
					imageDescription.append(PKStroke(ink: PKInk(.pen, color: .black), path: PKStrokePath(controlPoints: path, creationDate: Date())))
					path = []
					}
				}
			else if (token == "PKStrokePoint")
				{
				var location = CGPoint(x: 0, y: 0)
				var timeOffset: Double = 0
				var size = CGSize()
				var opacity: Double = 0
				var azimuth: Double = 0
				var force: Double = 0
				var altitude: Double = 0

				repeat
					{
					let token = parser.getToken()
					if (token == "location")
						{
						location = CGPoint(x: Double(parser.getToken())!, y: Double(parser.getToken())!)
						}
					else if (token == "timeOffset")
						{
						timeOffset = Double(parser.getToken())!
						}
					else if (token == "size")
						{
						size.width = Double(parser.getToken())!
						size.height = Double(parser.getToken())!
						}
					else if (token == "opacity")
						{
						opacity = Double(parser.getToken())!
						}
					else if (token == "azimuth")
						{
						azimuth = Double(parser.getToken())!
						}
					else if (token == "force")
						{
						force = Double(parser.getToken())!
						}
					else if (token == "altitude")
						{
						altitude = Double(parser.getToken())!
						break;
						}
					}
				while (true)
				let point = PKStrokePoint(location: location, timeOffset: timeOffset, size: size, opacity: opacity, force: force, azimuth: azimuth, altitude: altitude)
				path.append(point)
				}
			}
		while (true)

		imageDescription.append(PKStroke(ink: PKInk(.pen, color: .black), path: PKStrokePath(controlPoints: path, creationDate: Date())))
		let drawing = PKDrawing(strokes: imageDescription)
		return drawing.image(from: drawing.bounds, scale: 1)
		}

	var body: some View
		{
		VStack
	 		{
			Spacer().frame(height:20)
	 		Button("Load")
	 			{
				let panel = NSOpenPanel()
				panel.allowsMultipleSelection = false
				panel.canCreateDirectories = false
				panel.canChooseDirectories = false
				panel.canChooseFiles = true
				panel.allowedFileTypes = ["txt"]
				if panel.runModal() == .OK
					{
					picture = loadImage(panel.url?.absoluteURL)
					}
	 			}
			Spacer().frame(height:20)
			Image(nsImage: picture).resizable().scaledToFit()
			Spacer()
			}
		}
	}
