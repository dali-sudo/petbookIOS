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
    let defaults = UserDefaults.standard
    var body: some Scene {
        WindowGroup {

           // PetViewPager(id :"64222956e51b42f821d2f1ba")
            //LoginView()
          //  MapView()
           
            if  let token = defaults.string(forKey: "userId")
            {
                
            NavBarView()
               // MapView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
            }
            
            else {
              LoginView()
            
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
           
        }
    }
}
        
