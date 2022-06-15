//
//  DataContainer.swift
//  LeftHand
//
//  Created by andrew on 3/06/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "LeftHand")

    init() {
    container.loadPersistentStores { description, error in
        if let error = error {
            print("Core Data failed to load: \(error.localizedDescription)")
        }
    }
}
}
