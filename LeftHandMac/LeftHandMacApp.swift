/*
 LeftHandMacApp.swift
 */
import SwiftUI

@main
struct LeftHandMacApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {

        WindowGroup {
         
                ContentView().preferredColorScheme(.light).environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
