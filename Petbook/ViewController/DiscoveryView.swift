//
//  DiscoveryView.swift
//  Petbook
//
//  Created by user233432 on 4/17/23.
//

import Foundation
import SwiftUI



struct DiscoveryView: View {
    @ObservedObject var sviewModel:SearchUserViewModel = SearchUserViewModel()
    @State var posts: [DiscoverPostResponse] = []
    @State var list: [SearchResponse] = []
    @State private var isLoading: Bool = true
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
    @State private var text = ""
    private let searchDelay = 0.5 // Adjust this value as needed
    @State private var isEditing = false
    @State public  var  isNavigating = false
          
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        NavigationView {
        ScrollView {
            if(isLoading){
                ProgressView()
            }
            else
            {
              
                VStack{
                    HStack {
                                     Image(systemName: "magnifyingglass")
                                         .foregroundColor(.gray)
                                     Text("Search")
                                         .textFieldStyle(RoundedBorderTextFieldStyle())
                                         .padding()
                                 }
                                 .gesture(TapGesture().onEnded {
                                     self.isNavigating = true
                                     print("selected")
                                 })
                                 
                                 NavigationLink(destination: SearchView(), isActive: $isNavigating) {
                                     EmptyView()
                                 }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum : 100))], spacing: 1) {
                    ForEach(posts, id: \.self){ post in
                        VStack {
                            if let postpic = post.image{
                                if let imageData = Data(base64Encoded: postpic),
                                   let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 110, maxHeight: 100)
                                        .clipped()
                                    
                                    
                                }
                            }
                        }
                    }
                }
               
                
                    
                }
                } }.onAppear {
                print("ffdhé")
                viewModel.getRandomPosts(){ result in
                    isLoading = false
                    switch result {
                    case .success(let u):
                        
                        self.posts = u
                      // Handle successful sign-in
                        break
                        
                        
                    case .failure(let error):
                        // Handle sign                      -in error
                        // showWrong = true
                        
                        print("get posts error error:", error)
                        
                    }
                }
                
            }
            .onChange(of: viewModel.RandomPosts) { newValue in
                // Refresh view when user profile changes
            }
        }  }
func search() {
       print("Searching for \(text)...")
    sviewModel.Search(SearchText: text){ result in
        isLoading = false
        switch result {
        case .success(let u):
            
            self.list = u
          // Handle successful sign-in
            break
            
            
        case .failure(let error):
            // Handle sign                      -in error
            // showWrong = true
            
            print("get posts error error:", error)
            
        }
    }
    
}
   }


struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
