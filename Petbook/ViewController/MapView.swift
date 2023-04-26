//
//  MapView.swift
//  Petbook
//
//  Created by user233432 on 4/26/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

      var body: some View {
          Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
              .ignoresSafeArea()
              
          Circle()
              .fill(.blue)
              .opacity(0.3)
              .frame(width: 32,height : 32)         
          
      }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
