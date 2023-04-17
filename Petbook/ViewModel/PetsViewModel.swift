//
//  PetsViewModel.swift
//  Petbook
//
//  Created by user233432 on 4/9/23.
//

import Foundation
import UIKit

class PetsViewModel: ObservableObject {
    @Published var OwnedPets: [PetResponse] = []
    @Published var petAdded = false
     @Published var errorMessage = ""
      func fetchCards(for id: String) {
          print(id)
              guard let url = URL(string: "http://172.17.3.211:9090/pet/getAll") else {
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
                      print(cardsData.count , "******************")
                      DispatchQueue.main.async {
                          self.OwnedPets = cardsData
                      }
                  } catch {
                      fatalError("Error decoding response: \(error.localizedDescription)")
                  }
              }
              task.resume()
          }
    
    
    func addPet(owner: String, petName: String, petType: String, petRace: String, petSex: String, petBirthday: Date, petAvatar: UIImage?, completion: @escaping (Result<PetResponse, Error>) -> Void) {
        // Create URL
        guard let url = URL(string: "http://172.17.3.211:9090/pet/addPet") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Convert the birthday to age, and send the userID also
        let age = ageAsString(birthday: petBirthday)
        
        // Set request body
        let parameters: [String: Any] = [
            "owner" : owner,
            "name": petName,
            "type": petType,
            "race": petRace,
            "sex": petSex,
            "age": age,
            "avatar": petAvatar?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        // Send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let petResponse = try decoder.decode(PetResponse.self, from: data)
                                  
                    self.OwnedPets.insert(petResponse, at: 0)
                       
                    completion(.success(petResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    
    
    func ageAsString(birthday: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month], from: birthday, to: now)
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        let ageString = "\(years) years \(months) months"
        return ageString
    }

    
    
   
  }

                                                
