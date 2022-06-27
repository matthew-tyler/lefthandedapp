/*
	ContentView.swift
*/
import SwiftUI
import PencilKit
import CoreData

let UNKNOWN = "Unknown"

class Originator: ObservableObject
	{
	@Published var pen_path : Writing? = nil
	@Published var id: String = UNKNOWN
	@Published var sex: String = UNKNOWN
	@Published var age: String = UNKNOWN
	@Published var handedness: String = UNKNOWN
	@Published var writingHand: String = UNKNOWN
	@Published var qualifications: String = UNKNOWN
	@Published var authorRanking: [UUID] = []

	init()
		{
		rewind()
		}

	func rewind()
		{
		pen_path = nil
		id = UNKNOWN
		sex = UNKNOWN
		age = UNKNOWN
		handedness = UNKNOWN
		writingHand = UNKNOWN
		qualifications = UNKNOWN
		authorRanking = []
		}
	}

struct WritingView: View
	{
	var instance: Writing
	var drawing: PKDrawing
	var person: Person?
	@EnvironmentObject var originator: Originator

	var body: some View
		{
		Image(nsImage: drawing.image(from: originator.pen_path == nil ? PKDrawing().bounds : drawing.bounds, scale: 1)).frame(alignment: .topLeading)
		.onAppear()
			{
			originator.pen_path = instance
			if person == nil
				{
				originator.id = UNKNOWN
				originator.age = UNKNOWN
				originator.sex = UNKNOWN
				originator.qualifications = UNKNOWN
				originator.handedness = UNKNOWN
				originator.writingHand = UNKNOWN
				originator.authorRanking = []
				}
			else
				{
				originator.id = person!.id!.uuidString
				originator.age = person!.age!
				originator.sex = person!.sex!
				originator.qualifications = person!.qualifications!
				originator.handedness = person!.handedness!
				originator.writingHand = person!.writinghand!
				originator.authorRanking = person!.authorranks == nil ? [] : person!.authorranks!
				}
			}
		}
	}

struct ContentView: View
	{
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: [NSSortDescriptor(key: "person_id.description", ascending: true), NSSortDescriptor(keyPath: \Writing.type, ascending: true)]) var writing: FetchedResults<Writing>
	@FetchRequest(sortDescriptors: []) var person: FetchedResults<Person>

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
						if originator.pen_path != nil
							{
							moc.delete(originator.pen_path!)
							try? moc.save()
							originator.pen_path = nil
							}
						}
					Spacer().frame(width: 20)
					Button("DeleteAll")
						{
						for instance in writing
							{
							moc.delete(instance)
							}
						try? moc.save()
						originator.rewind()
						}
					Spacer().frame(width: 50)
					Button("Export")
						{
						if originator.pen_path != nil
							{
							for stroke in try! PKDrawing(data: originator.pen_path!.data!).strokes
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
					Spacer().frame(width: 20)
					Button("ExportAll")
						{
						for instance in writing
							{
							print(instance.type ?? UNKNOWN)
							for stroke in try! PKDrawing(data: instance.data!).strokes
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
					Text(" Writer:" + originator.writingHand)
					Spacer()
					}
				HStack
					{
					Text("Order:")
					if originator.authorRanking.count == 0
						{
						Text(UNKNOWN)
						}
					else
						{
						ForEach(originator.authorRanking, id: \.self )
							{ id in
							Text(id.uuidString)
							Text(" > ")
							}
						}
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
								let got = try! PKDrawing(data: instance.data!)
								NavigationLink(destination: WritingView(instance: instance, drawing: got, person: instance.person_id == nil ? nil : getItem(with:instance.person_id!)).environmentObject(originator))
									{
									Text(instance.type ?? UNKNOWN)
									}
								}
							}
							.listStyle(SidebarListStyle())
						}
					.onAppear
						{
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
							{
							/*
								This prevents the NavigationView from hiding the left hand pane.
							*/
							guard let nsSplitView = findNSSplitVIew(view: NSApp.windows.first?.contentView), let controller = nsSplitView.delegate as? NSSplitViewController else
								{
								return
								}
							controller.splitViewItems.first?.canCollapse = false
							controller.splitViewItems.first?.isCollapsed = false
							controller.splitViewItems.first?.minimumThickness = 300
							controller.splitViewItems.first?.maximumThickness = 300
							}
						}
					.frame(minWidth:250, alignment: .leading)
					Spacer()
					}
				}
			}
		}

	private func findNSSplitVIew(view: NSView?) -> NSSplitView?
		{
		var queue = [NSView]()
		if let root = view
			{
			queue.append(root)
			}
		while !queue.isEmpty
			{
			let current = queue.removeFirst()
			if current is NSSplitView
				{
				return current as? NSSplitView
				}
			for subview in current.subviews
				{
				queue.append(subview)
				}
			}
		return nil
		}
	}

extension NSTableView {
  open override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    backgroundColor = NSColor.white
    enclosingScrollView!.drawsBackground = false
  }
}
