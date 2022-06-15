/*
	Persistence.swift
*/
import CoreData

struct PersistenceController
	{
	static let shared = PersistenceController()

	let container: NSPersistentCloudKitContainer

	init(inMemory: Bool = false)
		{
		container = NSPersistentCloudKitContainer(name: "LeftHand")
		if inMemory
			{
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
			}
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.loadPersistentStores(completionHandler:
			{ (storeDescription, error) in
			if let error = error as NSError?
				{
				fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
		}
	}
