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

	func getPerson(with id: UUID?) -> Person?
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
					Button("Delete All")
						{
						/*
							Delete the scribbles
						*/
						for instance in writing
							{
							moc.delete(instance)
							}
						/*
							Delete the people
						*/
						for instance in person
							{
							moc.delete(instance)
							}
						try? moc.save()
						originator.rewind()
						}
					Spacer().frame(width: 50)

					Button("Export All")
						{
						var authors: Set<UUID> = []
						let panel = NSOpenPanel()
						panel.allowsMultipleSelection = false
						panel.canCreateDirectories = true
						panel.canChooseDirectories = true
						panel.canChooseFiles = false
						if panel.runModal() == .OK
							{
							let directory = panel.url?.absoluteURL
							for instance in writing
								{
								authors.insert(instance.person_id!)
								/*
									Save the pen path as a path
								*/
								let filename = directory!.appendingPathComponent(instance.id!.uuidString + ".txt")
								FileManager.default.createFile(atPath: filename.path, contents:"".data(using: .utf8))

								let fp = try! FileHandle(forWritingTo: filename)
								for stroke in try! PKDrawing(data: instance.data!).strokes
									{
									fp.write("Stroke\n".data(using: .utf8)!)
									stroke.path.forEach
										{ point in
										fp.write((String(describing: point) + "\n").data(using: .utf8)!)
										}
									}
								fp.closeFile()

								/*
									Save the image as a PNG
								*/
								let image = try! PKDrawing(data: instance.data!)
								let png = NSBitmapImageRep(data: image.image(from: image.bounds, scale:1).tiffRepresentation!)!.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0])
								try! png!.write(to: directory!.appendingPathComponent(instance.id!.uuidString + ".png"))
								}
							/*
								Step through the authors list and write that out too
							*/
							let csv_filename = directory!.appendingPathComponent("people" + ".csv")
							FileManager.default.createFile(atPath: csv_filename.path, contents:"".data(using: .utf8))
							let fp = try! FileHandle(forWritingTo: csv_filename)
							let csv_heading: String = "id,age,sex,education,handedness,writing hand,1,2,3,4,5,6,7,8\n"
							fp.write(csv_heading.data(using: .utf8)!)
							for instance in authors
								{
								let who = getPerson(with:instance)!
								var serialised: String = who.id!.uuidString + "," + who.age! + "," + who.sex! + "," + who.qualifications! + "," + who.handedness! + "," + who.writinghand!
								for id in who.authorranks!
									{
									serialised = serialised +  "," + id.uuidString
									}
								fp.write((serialised + "\n").data(using: .utf8)!)
								}
							fp.closeFile()
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
								NavigationLink(destination: WritingView(instance: instance, drawing: got, person: instance.person_id == nil ? nil : getPerson(with:instance.person_id!)).environmentObject(originator))
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

extension NSTableView
	{
	open override func viewDidMoveToWindow()
		{
		super.viewDidMoveToWindow()

		backgroundColor = NSColor.white
		enclosingScrollView!.drawsBackground = false
		}
	}
