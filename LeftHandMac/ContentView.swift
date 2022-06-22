/*
	ContentView.swift
*/
import SwiftUI
import PencilKit
import CoreData

let UNKNOWN = "Unknown"

class Originator: ObservableObject
	{
	@Published var id: String = UNKNOWN
	@Published var sex: String = UNKNOWN
	@Published var age: String = UNKNOWN
	@Published var handedness: String = UNKNOWN
	@Published var writingHand: String = UNKNOWN
	@Published var qualifications: String = UNKNOWN
	}


struct WritingView: View
	{
	var instance: Writing
	var drawing: PKDrawing
	var person: Person?
	@EnvironmentObject var originator: Originator

	var body: some View
		{
		Image(nsImage: drawing.image(from: drawing.bounds, scale: 1)).frame(alignment: .topLeading)
		.onAppear()
			{
			if person == nil
				{
				self.originator.id = UNKNOWN
				self.originator.age = UNKNOWN
				self.originator.sex = UNKNOWN
				self.originator.qualifications = UNKNOWN
				self.originator.handedness = UNKNOWN
				self.originator.writingHand = UNKNOWN
				}
			else
				{
				self.originator.id = person!.id!.uuidString
				self.originator.age = person!.age!
				self.originator.sex = person!.sex!
				self.originator.qualifications = person!.qualifications!
				self.originator.handedness = person!.handedness!
				self.originator.writingHand = person!.writinghand!
				}
			}
		}
	}

struct ContentView: View
	{
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Writing.person_id, ascending: true), NSSortDescriptor(keyPath: \Writing.type, ascending: true)]) var writing: FetchedResults<Writing>
	@FetchRequest(sortDescriptors: []) var person: FetchedResults<Person>
	@Environment(\.managedObjectContext) var moc

	@State var originatorUuidFilter = UUID()
	@State var drawing : PKDrawing = PKDrawing()
	@State var pen_path : Writing = Writing()

	@StateObject var originator = Originator()

	@State var selection: Writing? = nil

	func getItem(with id: UUID?) -> Person?
		{
		guard let id = id else { return nil }
		let request = Person.fetchRequest() as NSFetchRequest<Person>
		request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
		guard let items = try? moc.fetch(request) else { return nil }
		return items.first
		}


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
					NavigationView
						{
						List(selection: $selection)
							{
							ForEach(writing, id: \.self)
								{instance in
								NavigationLink(destination:
									WritingView(instance: instance,
									drawing: try! PKDrawing(data: instance.data!), person: instance.person_id == nil ? nil : getItem(with:instance.person_id!)).environmentObject(originator))
									{
									Text(instance.type ?? UNKNOWN)
									}
								}
							}.frame(width:300, alignment: .leading)
						}
					.frame(width:250, alignment: .leading)
					Spacer()
					}
				}
			}
		}
	}
