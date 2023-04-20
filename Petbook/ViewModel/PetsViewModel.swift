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
    @Published var isLoading = false
     @Published var errorMessage = ""
      func fetchCards(for id: String) {
          print(id)
              guard let url = URL(string: Utilities.url + "/pet/getAll") else {
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
                      self.isLoading = false
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
        guard let url = URL(string: Utilities.url + "/pet/addPet") else {
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
    
    func getPetProfile(petId: String, completion: @escaping (Result<Pet, Error>) -> Void) {
        print(petId)
            guard let url = URL(string: Utilities.url + "/pet/getSinglePet") else {
                fatalError("Invalid URL")
                
            }
            
        let parameters = ["_id": petId]
        
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
                    let petResponse = try decoder.decode(PetResponse.self, from: data)
                    let pet = Pet(name: petResponse.petName, type: petResponse.petType, owner:petResponse.petOwner, avatar:petResponse.petPic, sexe: petResponse.sexe, age: petResponse.petAge)
                    completion(.success(pet))
                    
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }

    func getPetImages(id: String, completion: @escaping ([UIImage]) -> Void) {
           
           let url = URL(string: Utilities.url + "/pet/getPetImages")!
        print(url)
           var request = URLRequest(url: url)
           
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let body: [String: Any] = ["_id": id]
           let jsonData = try! JSONSerialization.data(withJSONObject: body)
           
           request.httpBody = jsonData
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               guard let data = data else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                   completion([])
                   return
               }
               
               do {
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   let images = json?["images"] as? [String] ?? []
                   
                   let uiImages = images.compactMap { (base64String) -> UIImage? in
                       guard let data = Data(base64Encoded: base64String) else {
                           return nil
                       }
                       return UIImage(data: data)
                   }
                   
                   completion(uiImages)
               } catch {
                   print("Error: \(error.localizedDescription)")
                   completion([])
               }
           }
           
           task.resume()
       }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidData
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

                                                
