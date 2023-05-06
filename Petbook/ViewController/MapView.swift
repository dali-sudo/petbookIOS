                import SwiftUI
                import MapKit

        struct MapView: View {
            @State private var region: MKCoordinateRegion = MKCoordinateRegion.goldenGateRegion()
            @State var long : CLLocationDegrees?
            @State var lat : CLLocationDegrees?
            @ObservedObject var viewModel: MapApis=MapApis()
            @StateObject private var locationManager = LocationManager()
            @State var userLoc : CLLocation?
            @State private var zoomLevel: Double = 10000
                                
            struct Coordinate: Identifiable                          {
                let id = UUID()
                let coordinate: CLLocationCoordinate2D
                let name : String?
            
            }
            
    @State private var coords: [Coordinate] = []
    let coordinates: [Coordinate] = [
        Coordinate(coordinate: CLLocationCoordinate2D(latitude: 34, longitude: 9), name: "dd"),
        Coordinate(coordinate: CLLocationCoordinate2D(latitude: 35, longitude: 9), name: "dd")
       ]

            private func updateRegion() {
                if let location = locationManager.location {
                  
                    region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                } else {
                    region = MKCoordinateRegion.goldenGateRegion()
                }
            }

            
            var body: some View {
                VStack {
                    if let region = region {
                                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: coords) { annotation in
                                        MapAnnotation(coordinate: annotation.coordinate) {
                                            Button(action: {
                                                // Handle annotation tap
                                                print("Tapped on annotation \(annotation.name)")
                                            }) {
                                                VStack {
                                                    Image("petIcon")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                    Text(annotation.name!)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    }
                        .ignoresSafeArea()
                        .onAppear {
                            updateRegion()
                        }
                        .onChange(of: zoomLevel) { _ in
                            updateRegion()
                        }
                        .onChange(of: locationManager.location) { newLocation in
                            updateRegion()
                        }
                        .onReceive(locationManager.$location) { location in
                            if let location = location {
                                print ("found location")
                                long = location.coordinate.longitude
                                lat = location.coordinate.latitude
                                userLoc = CLLocation(latitude: lat!, longitude: long!)
                                if let userLoc = userLoc {
                                    viewModel.searchForPets(at: userLoc) { result in
                                        switch result {
                                            
                                        case .success(let data):
                                            // Handle success and parse data
                                            print("Received data: \(data)")
                                          coords = data
                                        case .failure(let error):
                                            // Handle error
                                            print("Error: \(error)")
                                        }

                                        // handle result
                                    }
                                }
                            }
                        }

                    }
                    Spacer()
                    HStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                zoomLevel *= 0.5
                                print("zoom is ", zoomLevel)
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                            })
                            Button(action: {
                                zoomLevel *= 2
                            }, label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 30))
                            })
                            Button(action: {
                                if let location = locationManager.location {
                                    print("hello")
                                    region.center = location.coordinate
                                }
                            }, label: {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 30))
                            })
                        }
                        .padding(.trailing, 15)
                        .padding(.bottom, 15)
                    }
                }
            }
        }
                

        struct MapWithUserLocation_Previews: PreviewProvider {
            static var previews: some View {
                MapView()
            }
        }


              
