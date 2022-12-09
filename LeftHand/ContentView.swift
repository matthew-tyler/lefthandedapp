/*
	ContentView.swift
*/
import SwiftUI
import PencilKit



// How to use:
// var conditions = ["A", "B", "C", "D"];
// balancedLatinSquare(conditions, 0)  //=> ["A", "B", "D", "C"]
// balancedLatinSquare(conditions, 1)  //=> ["B", "C", "A", "D"]
// balancedLatinSquare(conditions, 2)  //=> ["C", "D", "B", "A"]
// ...
// from:
// https://cs.uwaterloo.ca/~dmasson/tools/latin_square/
// ...
// NOTE:  Odd numbers need twice as many rows to be fully ballanced
func balancedLatinSquare(_ array: [String], _ participantId: Int) -> [String]
	{
	var result: [String] = []
	// Based on "Bradley, J. V. Complete counterbalancing of immediate sequential effects in a Latin square design. J. Amer. Statist. Ass.,.1958, 53, 525-528. "
	var j = 0, h = 0

	for i in 0 ..< array.count
		{
		var val = 0
		if (i < 2 || i % 2 != 0)
			{
			val = j
			j = j + 1
			}
		else
			{
			val = array.count - h - 1
			h = h + 1
			}

		let idx = (val + participantId) % array.count
		result.append(array[idx])
		}

	if (array.count % 2 != 0 && participantId % 2 != 0)
		{
		result.reverse()
		}

	return result
	}

struct ContentView: View
	{
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: []) var person: FetchedResults<Person>

	@State var parent: LeftHandApp

	let unSquaredMessage =
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
	@State private var canvasView = HighFidlityCanvas()

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
                    Spacer()
				HStack
					{
					Spacer().frame(width: 50)
					Image("OtagoLogo")
						.resizable()
						.aspectRatio(contentMode: .fit)
                        .frame(width:50, height:83, alignment: .center)
					Text("Please write " + balancedLatinSquare(unSquaredMessage, person.count)[current_message]).font(.title)
					Spacer()
					Button("Clear")
						{
						canvasView.drawing = PKDrawing()
                        canvasView.strokeCollection = PKDrawing()
                         
						}
						.padding()
						.foregroundColor(.white)
						.background(Color.blue.opacity(0.5))
						.clipShape(RoundedRectangle(cornerRadius: 5))
					Group
						{
						Spacer().frame(width:20)
						Button("Save")
							{
							parent.person.latinSquareOrder = Int32(person.count)
                                parent.person.scribbes[current_message] = Drawing(description: balancedLatinSquare(unSquaredMessage, person.count)[current_message], path: canvasView.drawing, highFidPath: canvasView.strokeCollection!)
                                
							current_message = (current_message + 1) % unSquaredMessage.count

							if current_message == 0
								{
								parent.coordinator.screen = Screen.order
								}
                                
							canvasView.drawing = PKDrawing()
                            canvasView.strokeCollection = PKDrawing()
							}
							.padding()
							.foregroundColor(.white)
							.background(Color.blue.opacity(0.5))
							.clipShape(RoundedRectangle(cornerRadius: 5))
						}
					Group
						{
						Spacer().frame(width:20)
						Button("QUIT")
							{
							parent.person.rewind()
							parent.coordinator.screen = Screen.conset
							}
							.padding()
							.foregroundColor(.white)
							.background(Color.red.opacity(0.5))
							.clipShape(RoundedRectangle(cornerRadius: 5))
						}

					Spacer().frame(width: 50)
					}.background(Color.white.opacity(0.5))
				Spacer().frame(width: 50)
				}
			}
		}
	}
