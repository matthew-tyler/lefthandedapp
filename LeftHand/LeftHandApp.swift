/*
	LeftHandApp.swift

	// https://www.hackingwithswift.com/books/ios-swiftui/how-to-combine-core-data-and-swiftui
*/

import SwiftUI

@main
struct LeftHandApp: App
	{
	@StateObject private var dataController = DataController()

	var body: some Scene
		{
		WindowGroup
			{
			ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
			}
		}
	}
