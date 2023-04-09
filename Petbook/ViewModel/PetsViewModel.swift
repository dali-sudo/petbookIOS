//
//  PetsViewModel.swift
//  Petbook
//
//  Created by user233432 on 4/9/23.
//

import Foundation

class PetsViewModel: ObservableObject {
    @Published var OwnedPets: [PetResponse] = []
      
      func fetchCards(for id: String) {
          print(id)
              guard let url = URL(string: "https://9e45-102-159-177-58.eu.ngrok.io/pet/getAll") else {
                  fatalError("Invalid URL")
              }
              
          let parameters = ["owner": id]
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
                                
              let session = URLSession.shared
              let task = session.dataTask(with: request) { data, response, error in
                  guard let data = data else {
                      fatalError("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                  }
                  
                  do {
                      let decoder = JSONDecoder()
                      let cardsData = try decoder.decode([PetResponse].self, from: data)
                      DispatchQueue.main.async {
                          self.OwnedPets = cardsData
                      }
                  } catch {
                      fatalError("Error decoding response: \(error.localizedDescription)")
                  }
              }
              task.resume()
          }
  }

                                                
