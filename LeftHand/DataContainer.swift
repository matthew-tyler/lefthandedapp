/*
	DataContainer.swift
*/
import Foundation
import CoreData

class DataController: ObservableObject
	{
	let container = NSPersistentCloudKitContainer(name: "LeftHand")

	init()
		{
		container.loadPersistentStores
			{ description, error in
			if let error = error
				{
				print("Core Data failed to load: \(error.localizedDescription)")
				}
			}
		}
	}
