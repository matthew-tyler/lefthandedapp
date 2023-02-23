/*
	LeftHandApp.swift
*/
import SwiftUI
import PencilKit

let UNKNOWN = "Withheld"
let UNKNOWN_ORDER: Int32 = -1

enum Screen
	{
	case consent
	case demographics
	case writings
	case order
    case calibration
	}

final class AppCoordinator: ObservableObject
	{
	@Published var screen: Screen = .demographics

	init()
		{
		screen = .consent
		}
	}

struct Drawing : Identifiable, Equatable
	{
    let id = UUID()
	var description : String = ""
	var path = PKDrawing()
    var highFidPath = PKDrawing()
    // The orientation of the tablet, relative to the edge of the table
    var orientation: Double = 0.0

    init(description: String, path: PKDrawing, highFidPath: PKDrawing)
		{
		self.description = description
		self.path = path
        self.highFidPath = highFidPath
		}
    // orverloaded to set orientation
    init(description: String, path: PKDrawing, highFidPath: PKDrawing,orientation: Double)
        {
        self.description = description
        self.path = path
        self.highFidPath = highFidPath
        self.orientation = orientation

        }
    

	}


final class User
	{
	var id = UUID()
	var sex: String = UNKNOWN
	var age: String = UNKNOWN
	var handedness: String = UNKNOWN
	var writingHand: String = UNKNOWN
    var writingHabit: String = UNKNOWN
    var stylusHabit: String = UNKNOWN
	var educationLevel: String = UNKNOWN
	var scribbes: [Drawing] = []
	var authorRanking: [UUID] = []
	var latinSquareOrder: Int32 = UNKNOWN_ORDER
    
	init()
		{
		rewind()
		}

	func rewind()
		{
		id = UUID()
		sex = UNKNOWN
		age = UNKNOWN
		handedness = UNKNOWN
		writingHand = UNKNOWN
		educationLevel = UNKNOWN
		scribbes = []
		scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
        scribbes.append(Drawing(description: UNKNOWN, path: PKDrawing(),highFidPath: PKDrawing()))
		authorRanking = []
		latinSquareOrder = UNKNOWN_ORDER
		}
	}

@main
struct LeftHandApp: App
	{
	
	@Environment(\.managedObjectContext) var moc

    @StateObject var coordinator = AppCoordinator()
	@StateObject private var dataController = DataController()
    @StateObject var motionDetector = MotionDetector(updateInterval: 0.1).started()
    
	var person = User()

	var body: some Scene
		{
		WindowGroup
			{
			switch (coordinator.screen)
				{
				case .consent:
					ConsentView(self)
				case .demographics:
					DemographicsView(self, result: person)
				case .writings:
                    ContentView(self).environment(\.managedObjectContext, dataController.container.viewContext).ignoresSafeArea().defersSystemGestures(on: .bottom).persistentSystemOverlays(.hidden).environmentObject(motionDetector)
				case .order:
					OrderingView(self).environment(\.managedObjectContext, dataController.container.viewContext)
                case .calibration:
                    CalibrationView(parent: self).environmentObject(motionDetector)
				}
			}
		}
	}
