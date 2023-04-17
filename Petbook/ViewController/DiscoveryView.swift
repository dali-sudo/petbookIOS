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
    @State private var isLoading: Bool = true
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
   
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            if(isLoading){
                ProgressView()
            }
            else
            {
                
                
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(posts, id: \.self){ post in
                        VStack {
                            if let postpic = post.image{
                                if let imageData = Data(base64Encoded: postpic),
                                   let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: ContentMode.fit)
                                    
                                    
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                
            }}.onAppear {
                print("ffdhé")
                viewModel.getRandomPosts(){ result in
                    isLoading = false
                    switch result {
                    case .success(let u):
                        
                        self.posts = u          // Handle successful sign-in
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
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
