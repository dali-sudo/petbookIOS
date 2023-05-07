        //
        //  MapApis.swift
        //  Petbook
        //
        //  Created by user233432 on 5/5/23.
        //

        import Foundation
        import CoreLocation
        class MapApis : ObservableObject {
            func searchForPets(at location: CLLocation, completion: @escaping (Result<[MapView.Coordinate], Error>) -> Void) {
            
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let query = "pets"
                let url = URL(string: "https://api.foursquare.com/v3/places/search?ll=\(latitude),\(longitude)&query=\(query)")!
                var urlRequest = URLRequest(url: url)
                urlRequest.addValue("fsq3AA1ZspCuUbwHjIK1IprSw3IjV7T6yxEGaQN5fM5nYDQ=", forHTTPHeaderField: "Authorization")
                let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let data = data else {
                        let error = NSError(domain: "MapApis", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        completion(.failure(error))
                        return
                    }
                    if let responseString = String(data: data, encoding: .utf8) {
                        print(responseString, "respssss")
                    }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let results = json["results"] as? [[String: Any]] else {
                        let error = NSError(domain: "MapApis", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON"])
                        completion(.failure(error))
                        return
                    }

                    var coordinates = [MapView.Coordinate]()
                                            for result in results {
                                                    if let geocodes = result["geocodes"] as? [String: Any],
                                                       let mainGeocode = geocodes["main"] as? [String: Double],
                                                       let latitude = mainGeocode["latitude"],
                                                       let longitude = mainGeocode["longitude"],
                                                       let name = result["name"] as? String,
                                                       let location = result["location"] as? [String: Any],
                                                       let address = location["formatted_address"] as? String
                                                {
                                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                                    do {
                                                        let coordinateObject = try MapView.Coordinate(coordinate: coordinate, name : name , image : "petIcon", address : address)
                                                        coordinates.append(coordinateObject)
                                                    } catch {
                                                        print("Error: \(error.localizedDescription)")
                                                    }
                                                    
                                                }
                                            }
                                                    
                    completion(.success(coordinates))
                }

                task.resume()
            }
        }

