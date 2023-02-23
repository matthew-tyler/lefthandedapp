/*
 DataContainer.swift
 */
import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "LeftHand")

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
