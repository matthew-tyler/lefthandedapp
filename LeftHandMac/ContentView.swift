/*
	ContentView.swift
*/
import SwiftUI
import PencilKit
import CoreData

let UNKNOWN = "Unknown"

final class Originator
	{
	var id: String = UNKNOWN
	var sex: String = UNKNOWN
	var age: String = UNKNOWN
	var handedness: String = UNKNOWN
	var writingHand: String = UNKNOWN
	var qualifications: String = UNKNOWN
	}


//struct ContentView: View {
//    @State var selection: Int? = 0
//
//    func changeSelection(_ by: Int) {
//        switch self.selection {
//        case .none:
//            self.selection = 0
//        case .some(let sel):
//            self.selection = max(min(sel + by, 20), 0)
//        }
//    }
//
//    var body: some View {
//        HStack {
//            List((0..<20), selection: $selection) {
//                Text(String($0))
//            }
//            VStack {
//                Button(action: { self.changeSelection(-1) }) {
//                    Text("Move Up")
//                }
//                Button(action: { self.changeSelection(1) }) {
//                    Text("Move Down")
//                }
//            }
//        }
//    }
//}

struct ContentView: View
	{
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Writing.person_id, ascending: true), NSSortDescriptor(keyPath: \Writing.type, ascending: true)]) var writing: FetchedResults<Writing>
	@FetchRequest(sortDescriptors: []) var person: FetchedResults<Person>
	@Environment(\.managedObjectContext) var moc

	@State var originatorUuidFilter = UUID()
	@State var drawing : PKDrawing = PKDrawing()
	@State var pen_path : Writing = Writing()

	@State var originator = Originator()

	@State var selection: Writing? = nil

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
					Spacer()
					Text("ID:" + originator.id)
					Text(" Age:" + originator.age)
					Text(" Sex:" + originator.sex)
					Text(" Qual:" + originator.qualifications)
					Text(" Hand:" + originator.handedness)
					Text(" Writing:" + originator.writingHand)
					Spacer()
					}
				Divider()
				HStack
					{
					List(selection: $selection)
						{
						ForEach(writing, id: \.self)
							{instance in
							Text(instance.type ?? UNKNOWN)
							.frame(width: 300, alignment: .leading)
							.onTapGesture
								{
								do
									{
									selection = instance
									pen_path = instance
									drawing = try PKDrawing(data: pen_path.data!)
									originator = Originator()

									if instance.person_id != nil, let got = getItem(with:instance.person_id!)
										{
										originator.id = got.id!.uuidString
										originator.age = got.age!
										originator.sex = got.sex!
										originator.qualifications = got.qualifications!
										originator.handedness = got.handedness!
										originator.writingHand = got.writinghand!
										}
									}
								catch
									{
									print(error)
									}
								}
							}
						}
					.frame(width:250, alignment: .leading)
					Spacer().frame(width: 10)
					Divider()
					Image(nsImage: drawing.image(from: drawing.bounds, scale: 1)).frame(alignment: .topLeading)
					Spacer()
					}
				}
			}
		}

	func getItem(with id: UUID?) -> Person?
		{
		guard let id = id else { return nil }
		let request = Person.fetchRequest() as NSFetchRequest<Person>
		request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
		guard let items = try? moc.fetch(request) else { return nil }
		return items.first
		}

	}
