/*
	LeftHandApp.swift
*/
import SwiftUI

enum Screen
	{
	case conset
	case demographics
	case writings
	}

final class AppCoordinator: ObservableObject
	{
	@Published var screen: Screen = .demographics

	init()
		{
		screen = .conset
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
				}
			}
		}
	}
