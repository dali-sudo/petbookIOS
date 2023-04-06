//
//  PetbookApp.swift
//  Petbook
//
//  Created by user233432 on 3/10/23.
//

import SwiftUI

@main
struct PetbookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
         LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
