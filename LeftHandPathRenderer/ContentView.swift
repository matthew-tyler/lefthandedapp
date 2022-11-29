/*
	ContentView.swift
*/

import SwiftUI
import PencilKit

import Charts

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
    
    
    @State var drawing: PKDrawing = PKDrawing()
	@State var picture: NSImage = NSImage()
    @State var parser = Parser(document: "")
    
    
    @State var data : [Fourier.v_point] = []
    @State var transformed : [Float] = []
    
    @State  var toPlot : [Mark] = []
    
    var fft = Fourier()
    

	func loadDrawing(_ filename: URL?) -> PKDrawing
		{
            
		let image = PKDrawing()
            
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
		return drawing
		}
    
    
    
    func setPicture(_ drawing: PKDrawing) -> NSImage {
        
        return drawing.image(from: drawing.bounds, scale: 1)
    }
    
    struct Mark: Identifiable{
        let id = UUID()
        let x : Float
        let y : Float
        
    }
    
    func makePlotable(_ arr: [Float]) -> [Mark]{
        var count = Float(-1.0);
        
        let midpoint   = arr.count / 4
        
        var halfArr  = arr [..<midpoint]
        
        
        let mean = arr.first
        
        halfArr.removeFirst()
        
        let minusMean = halfArr.map(){ $0 - mean!}
        
        var sum = minusMean.reduce(0,+)
        
        sum = pow(sum,2)
        
        let stdDev = sqrt((sum / Float(halfArr.count)))
        
        
        var out = halfArr.map{ count+=1.0; return  Mark(x : count, y : ($0 / mean! ) );  }
        
   
        
      
        
        
        return out
        
    }
    
    

    

    
	var body: some View
		{
		VStack
	 		{
			Spacer().frame(height:20)
                
                HStack{
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
                            drawing = loadDrawing(panel.url?.absoluteURL)
                            picture = setPicture(drawing)
                        }
                    }
                    
                    Button("FFT"){
                        
                        data = fft.vectorise(drawing);
                        
                        
                        transformed = fft.transform(data)
                        
                        toPlot = makePlotable(transformed)
           
                    }
                }
			Spacer().frame(height:20)
			Image(nsImage: picture).resizable().scaledToFit()
                
                Spacer()
               
                if #available(macOS 13.0, *) {
                    Chart(data){
                        LineMark( x: .value("time",$0.time), y: .value("Distance", $0.distance))
                        
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                Spacer()
                if #available(macOS 13.0, *) {

 
                    Chart(toPlot){
                        
                        BarMark(
                            x: .value("F", $0.x),
                                      y: .value("Profit", $0.y)
                        )

                    }
                } else {
                    // Fallback on earlier versions
                }

                
			}
		}
	}
