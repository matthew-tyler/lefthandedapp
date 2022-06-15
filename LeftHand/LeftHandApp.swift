/*
	LeftHandApp.swift
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
