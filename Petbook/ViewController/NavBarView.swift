//
//  NavBarView.swift
//  Petbook
//
//  Created by user233432 on 4/5/23.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "list.dash")
                        .foregroundColor(.yellow)
                    Text("Feed")
                        .foregroundColor(.yellow)
                }
            DiscoveryView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.yellow)
                    Text("Discover")
                        .foregroundColor(.yellow)
                }
            MapView()
                .tabItem {
                    Image(systemName: "map")
                        .foregroundColor(.yellow)
                    Text("Map")
                        .foregroundColor(.yellow)
                }
         ChatListView()
                .tabItem {
                    Image(systemName: "message")
                        .foregroundColor(.yellow)
                    Text("Chat")
                        .foregroundColor(.yellow)
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                        .foregroundColor(.yellow)
                    Text("Profile")
                        .foregroundColor(.yellow)
                }
        }
        .accentColor(.yellow)
    }
}


struct DiscoverView: View {
    var body: some View {
        Text("This is the Discover View")
    }
}



struct ChatView: View {
    var body: some View {
        Text("This is the Chat View")
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
