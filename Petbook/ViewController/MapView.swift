import SwiftUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion.goldenGateRegion()

    @StateObject private var locationManager = LocationManager()
    
    @State private var zoomLevel: Double = 10000
    
    struct Coordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    let coordinates: [Coordinate] = [
        Coordinate(coordinate: CLLocationCoordinate2D(latitude: 34, longitude: 9)),
        Coordinate(coordinate: CLLocationCoordinate2D(latitude: 35, longitude: 9))
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
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: coordinates) { coordinate in
                    MapMarker(coordinate: coordinate.coordinate)
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
