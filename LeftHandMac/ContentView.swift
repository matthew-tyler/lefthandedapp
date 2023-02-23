/*
 ContentView.swift
 */
import CoreData
import PencilKit
import SwiftUI

func dateToString(date: Date?) -> String {
    if date == nil {
        return ""
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    return dateFormatter.string(from: date!)
}

struct PersonView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
    var person: Person

    func getImage(with id: UUID?) -> (NSImage?, Writing?) {
        guard let id = id else { return (nil, nil) }
        let request = Writing.fetchRequest() as NSFetchRequest<Writing>
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return (nil, nil) }

        let imageData = items.first
        let path = try! PKDrawing(data: imageData!.data!)
        return (path.image(from: path.bounds, scale: 1), imageData)
    }

    let imageIndexes = Array([0, 1, 2, 3, 4, 5, 6, 7])

    func getRanks() -> [UUID] {
        return person.authorranks!
    }

    var body: some View {
        VStack {
            let scaleFactor = 4.0
            Spacer().frame(height: 20)
            HStack {
                Spacer()
                Text("Id:" + person.id!.uuidString)
                Text(" Age:" + person.age!)
                Text(" Sex:" + person.sex!)
                Text(" Qual:" + person.qualifications!)
                Text(" Handedness:" + person.handedness!)
                if let habit = person.writinghabit {
                    Text(" Habit:" + habit)
                }
                Group {
                    Text(" Writing Hand:" + person.writinghand!)
                    Text(" When:" + dateToString(date: person.date))
                    Text(" LatinOrder:" + String(person.latinsquareorder))
                }
                Spacer()
            }
            Spacer().frame(height: 20)
            HStack(alignment: .lastTextBaseline) {
                ForEach(0 ... 3, id: \.self) { image in
                    VStack {
                        let id = getRanks()[imageIndexes[image]]
                        let (img, data) = getImage(with: id)
                        Image(nsImage: img!).resizable().scaledToFit().frame(width: img!.size.width / scaleFactor, height: img!.size.height / scaleFactor).border(.black)
                        Text("Id:" + id.uuidString)
                        if let orientation = data?.orientation {
                            Text("Orientation:" + String(format: "%.0f", orientation))
                        }
                        Text(data!.type!)

                    }.id(UUID())
                }
            }

            Spacer().frame(height: 20)
            HStack(alignment: .lastTextBaseline) {
                ForEach(4 ... 7, id: \.self) { image in
                    VStack {
                        let id = getRanks()[imageIndexes[image]]
                        let (img, data) = getImage(with: id)
                        Image(nsImage: img!).resizable().scaledToFit().frame(width: img!.size.width / scaleFactor, height: img!.size.height / scaleFactor).border(.black)
                        Text("Id:" + id.uuidString)
                        if let orientation = data?.orientation {
                            Text("Orientation:" + String(format: "%.0f", orientation))
                        }
                        Text(data!.type!)

                    }.id(UUID())
                }
            }

            Spacer().frame(height: 20)
            Spacer()
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "person_id.description", ascending: true), NSSortDescriptor(keyPath: \Writing.type, ascending: true)]) var writing: FetchedResults<Writing>
    @FetchRequest(sortDescriptors: []) var person: FetchedResults<Person>

    @State var selection: Person? = nil

    func getPerson(with id: UUID?) -> Person? {
        guard let id = id else { return nil }
        let request = Person.fetchRequest() as NSFetchRequest<Person>
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return nil }
        return items.first
    }

    func getImage(with id: UUID?) -> Writing? {

        guard let id = id else { return nil }

        let request = Writing.fetchRequest() as NSFetchRequest<Writing>
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return nil }

        return items.first
    }

    func getImagesByPerson(with id: UUID?) -> [Writing]? {

        guard let id = id else { return nil }

        let request = Writing.fetchRequest() as NSFetchRequest<Writing>
        request.predicate = NSPredicate(format: "%K == %@", "person_id", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return nil }

        print(items)

        return items
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Button("Delete") {
                        if self.selection != nil {
                            for image in self.selection!.authorranks! {
                                moc.delete(getImage(with: image)!)
                            }
                            moc.delete(self.selection!)
                            self.selection = nil
                            try? moc.save()
                        }
                    }
                    Spacer().frame(width: 20)
                    Button("Delete All") {
                        /*
                         	Delete the scribbles
                         */
                        for instance in writing {
                            moc.delete(instance)
                        }
                        /*
                         	Delete the people
                         */
                        for instance in person {
                            moc.delete(instance)
                        }
                        try? moc.save()
                    }

                    Spacer().frame(width: 50)

                    Button("Export This") {
                        if let samples = getImagesByPerson(with: selection?.id) {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            panel.canCreateDirectories = true
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            if panel.runModal() == .OK {
                                let directory = panel.url?.absoluteURL

                                for sample in samples {
                                    let filename = directory!.appendingPathComponent(sample.id!.uuidString + ".txt")
                                    FileManager.default.createFile(atPath: filename.path, contents: "".data(using: .utf8))
                                    let fp = try! FileHandle(forWritingTo: filename)
                                    for stroke in try! PKDrawing(data: sample.data!).strokes {
                                        fp.write("Stroke\n".data(using: .utf8)!)
                                        stroke.path.forEach { point in
                                            fp.write((String(describing: point) + "\n").data(using: .utf8)!)
                                        }
                                    }
                                    fp.closeFile()
                                    /*
                                     Save the image as a PNG
                                     */
                                    let image = try! PKDrawing(data: sample.data!)
                                    let png = NSBitmapImageRep(data: image.image(from: image.bounds, scale: 1).tiffRepresentation!)!.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0])
                                    try! png!.write(to: directory!.appendingPathComponent(sample.id!.uuidString + ".png"))

                                    let hfFilename = directory!.appendingPathComponent(sample.id!.uuidString + ".txt")
                                    FileManager.default.createFile(atPath: hfFilename.path, contents: "".data(using: .utf8))

                                    let hffp = try! FileHandle(forWritingTo: hfFilename)

                                    for hfStroke in try! PKDrawing(data: sample.highFidData!).strokes
                                    {
                                        hffp.write("Stroke\n".data(using: .utf8)!)
                                        hfStroke.path.forEach { point in
                                            hffp.write((String(describing: point) + "\n").data(using: .utf8)!)
                                        }
                                    }
                                    hffp.closeFile()
                                }
                            }
                        }
                    }
                    Spacer().frame(width: 50)

                    Button("Export All") {
                        var authors: Set<UUID> = []
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canCreateDirectories = true
                        panel.canChooseDirectories = true
                        panel.canChooseFiles = false
                        if panel.runModal() == .OK {
                            let directory = panel.url?.absoluteURL
                            for instance in writing {
                                authors.insert(instance.person_id!)
                                /*
                                 	Save the pen path as a path
                                 */
                                let filename = directory!.appendingPathComponent(instance.id!.uuidString + ".txt")
                                FileManager.default.createFile(atPath: filename.path, contents: "".data(using: .utf8))

                                let fp = try! FileHandle(forWritingTo: filename)
                                for stroke in try! PKDrawing(data: instance.highFidData!).strokes {
                                    fp.write("Stroke\n".data(using: .utf8)!)
                                    stroke.path.forEach { point in
                                        fp.write((String(describing: point) + "\n").data(using: .utf8)!)
                                    }
                                }
                                fp.closeFile()

                                /*
                                 	Save the image as a PNG
                                 */
                                let image = try! PKDrawing(data: instance.highFidData!)
                                let png = NSBitmapImageRep(data: image.image(from: image.bounds, scale: 1).tiffRepresentation!)!.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0])
                                try! png!.write(to: directory!.appendingPathComponent(instance.id!.uuidString + ".png"))
                            }

                            /*
                             	Step through the authors list and write that out too
                             */
                            var csv_filename = directory!.appendingPathComponent("people" + ".csv")
                            FileManager.default.createFile(atPath: csv_filename.path, contents: "".data(using: .utf8))
                            var fp = try! FileHandle(forWritingTo: csv_filename)
                            var csv_heading = "id,when,age,sex,education,handedness,writing hand,writing habit,stylus habit,latin order,1,2,3,4,5,6,7,8\n"
                            fp.write(csv_heading.data(using: .utf8)!)
                            for instance in authors {
                                let who = getPerson(with: instance)!

                                let writinghabit = who.writinghabit ?? ""
                                let stylusHabit = who.stylusHabit ?? ""

                                var serialised: String = who.id!.uuidString + "," + dateToString(date: who.date) + "," + who.age! + "," + who.sex! + "," + who.qualifications! + "," + who.handedness! + "," + who.writinghand! + "," + writinghabit + "," + stylusHabit + "," + String(who.latinsquareorder)

                                for id in who.authorranks! {
                                    serialised = serialised + "," + id.uuidString
                                }
                                fp.write((serialised + "\n").data(using: .utf8)!)
                            }
                            fp.closeFile()

                            /*
                             	Step through the image list and write the meta-data
                             */
                            csv_filename = directory!.appendingPathComponent("images" + ".csv")
                            FileManager.default.createFile(atPath: csv_filename.path, contents: "".data(using: .utf8))
                            fp = try! FileHandle(forWritingTo: csv_filename)
                            csv_heading = "id,author,orientation,grip,hand\n"
                            fp.write(csv_heading.data(using: .utf8)!)
                            for instance in writing {
                                let serialised: String = instance.id!.uuidString + "," + instance.person_id!.uuidString + "," + instance.type! + "\n"
                                fp.write(serialised.data(using: .utf8)!)
                            }
                            fp.closeFile()
                        }
                    }
                }
                Divider()
                HStack {
                    NavigationView {
                        List(selection: $selection) {
                            ForEach(person, id: \.self) { instance in
                                NavigationLink(destination: PersonView(person: instance)) {
                                    Text(instance.id!.uuidString)
                                }
                            }
                        }
                        .listStyle(SidebarListStyle())
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            /*
                             	This prevents the NavigationView from hiding the left hand pane.
                             */
                            guard let nsSplitView = findNSSplitVIew(view: NSApp.windows.first?.contentView), let controller = nsSplitView.delegate as? NSSplitViewController
                            else {
                                return
                            }
                            controller.splitViewItems.first?.canCollapse = false
                            controller.splitViewItems.first?.isCollapsed = false
                            controller.splitViewItems.first?.minimumThickness = 330
                            controller.splitViewItems.first?.maximumThickness = 330
                        }
                    }
                    .frame(minWidth: 250, alignment: .leading)
                    Spacer()
                }
            }
        }
    }

    private func findNSSplitVIew(view: NSView?) -> NSSplitView? {
        var queue = [NSView]()
        if let root = view {
            queue.append(root)
        }
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current is NSSplitView {
                return current as? NSSplitView
            }
            for subview in current.subviews {
                queue.append(subview)
            }
        }
        return nil
    }
}

extension NSTableView {
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        backgroundColor = NSColor.white
        enclosingScrollView?.drawsBackground = false
    }
}
