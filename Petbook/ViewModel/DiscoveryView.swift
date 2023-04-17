//
//  DiscoveryView.swift
//  Petbook
//
//  Created by user233432 on 4/17/23.
//

import Foundation
import SwiftUI



struct DiscoveryView: View {
    @State var posts: [DiscoverPostResponse] = []
    @State private var isLoading: Bool = false
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                List(viewModel.RandomPosts!, id: \.self){ post in
                    VStack {
                        if let postpic = post.image{
                            if let imageData = Data(base64Encoded: post.image),
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                   
                            }
                        }
                       
                          
                        
                        
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .onAppear {
                viewModel.getRandomPosts(){ result in
                    isLoading = false
                    switch result {
                    case .success(let u):
                      
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
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
