/*
	LeftHandApp.swift
*/
import SwiftUI
import PencilKit

enum Screen
	{
	case conset
	case demographics
	case writings
	case order
	}

final class AppCoordinator: ObservableObject
	{
	@Published var screen: Screen = .demographics

	init()
		{
		screen = .conset
		}
	}

struct Drawing : Identifiable, Equatable
	{
   let id = UUID()
	var description : String = ""
	var path = PKDrawing()
	var author_ranking : Int = 0

	init(description: String, path: PKDrawing)
		{
		self.description = description
		self.path = path
		author_ranking = 0;
		}
	}

final class User
	{
	var id = UUID()
	var sex: String = "Unknown"
	var age: String = "Unknown"
	var handedness: String = "Unknown"
	var writingHand: String = "Unknown"
	var educationLevel: String = "Unknown"
	var scribbes: [Drawing] = []

	init()
		{
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		scribbes.append(Drawing(description: "Unknown", path: PKDrawing()))
		}
	}

@main
struct LeftHandApp: App
	{
	
	@Environment(\.managedObjectContext) var moc

	@StateObject var coordinator = AppCoordinator()
	@StateObject private var dataController = DataController()
	var person = User()

	var body: some Scene
		{
		WindowGroup
			{
			switch (coordinator.screen)
				{
				case .conset:
					ConsentView(self)
				case .demographics:
					DemographicsView(self, result: person)
				case .writings:
					ContentView(self).environment(\.managedObjectContext, dataController.container.viewContext)
				case .order:
					OrderingView(self).environment(\.managedObjectContext, dataController.container.viewContext)
				}
			}
		}
	}
