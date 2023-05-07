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
            @State private var selectedCoordinate: Coordinate?
            @State private var showSheet = false

            struct Coordinate: Identifiable                          {
                let id = UUID()
                let coordinate: CLLocationCoordinate2D
                let name : String?
                let image : String?
                let address : String?
            
            }
            
            private func coordinateTapped(_ coordinate: Coordinate) {
                selectedCoordinate = Coordinate(coordinate: coordinate.coordinate,
                                                            name: coordinate.name,
                                                            image: "petIcon",
                                                address: coordinate.address)
              
            }
            struct RoundedCorner: Shape {
                var radius: CGFloat
                var corners: UIRectCorner

                func path(in rect: CGRect) -> Path {
                    let path = UIBezierPath(
                        roundedRect: rect,
                        byRoundingCorners: corners,
                        cornerRadii: CGSize(width: radius, height: radius))
                    return Path(path.cgPath)
                }
            }
    @State private var coords: [Coordinate] = []
   
                                            
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
                                 Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: coords) { coordinate in
                                     MapAnnotation(coordinate: coordinate.coordinate) {
                                         Button(action: {
                                             coordinateTapped(coordinate)
                                             }, label: {
                                                 Image("mapMarker")
                                                     .resizable()
                                                     .aspectRatio(contentMode: .fit)
                                                     .frame(width: 30, height: 30)
                                                     .background(Color.clear)
                                             })
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
                    
                    if let selectedCoordinate = selectedCoordinate {
                        HStack {
                            Image(selectedCoordinate.image ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            VStack {
                                
                                Text(selectedCoordinate.name ?? "")
                                Text(selectedCoordinate.address ?? "")
                            }
                           
                        }
                        .frame(height: 150)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        .padding()
                        .onTapGesture {
                            self.selectedCoordinate = nil
                        }
                        .transition(.move(edge: .bottom))
                    }


                    
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


              
