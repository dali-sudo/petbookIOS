//
//  FeedView.swift
//  Petbook
//
//  Created by user233432 on 4/5/23.
//

import SwiftUI
struct Post: Identifiable {
    var id = UUID()
    var username: String
    var postImage: String
    var likes: Int
    var caption: String
}

struct FeedView: View {
    @State private var isLoading: Bool = true
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
    let posts = [
        Post(username: "johndoe", postImage: "post1", likes: 103, caption: "Beautiful view from my window."),
        Post(username: "janedoe", postImage: "post2", likes: 232, caption: "Spent the weekend hiking with my dog."),
        Post(username: "johndoe", postImage: "post3", likes: 527, caption: "Best meal I've had in a while!"),
        Post(username: "janedoe", postImage: "post4", likes: 387, caption: "Just finished reading this book and it was amazing."),
        Post(username: "johndoe", postImage: "post5", likes: 198, caption: "Celebrating my birthday with my friends."),
        Post(username: "janedoe", postImage: "post6", likes: 467, caption: "Finally finished this painting after weeks of work."),
    ]
    var body: some View {
        NavigationView {
            ZStack{    if(isLoading){
                ProgressView()
            }
                else{
            VStack{
                
                
                List(viewModel.Posts!, id: \._id) { post in
                           PostView(post: post)
                       }
                
                .navigationBarTitle("PetBook")
               
            }
                VStack {
                                 Spacer()
                                 HStack {
                                     Spacer()
                                    
                                      NavigationLink(destination: AddPostView().navigationBarBackButtonHidden(true)) {
                                            
                                         Image(systemName: "plus.circle.fill")
                                             .font(.system(size: 50))
                                             .foregroundColor(.blue)
                                     }
                                     .padding(.trailing, 20)
                                     .padding(.bottom, 20)
                                 }
                             }
                             
                         }
            }.onAppear{
                
                viewModel.getPosts(){ result in
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
            }      .onChange(of: viewModel.Posts) { newValue in
                // Refresh view when user profile changes
            }
           
            
        }
    }
    
}
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
struct PostView: View {
    
    let post: GetPostResponseData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.owner.username)
               
               
            Spacer()
            if let postpic = post.images {
                if let imageData = Data(base64Encoded: post.images![0]),
                   let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipped()
                        .cornerRadius(20)
                        .overlay(
                            VStack {
                                Spacer()
                                HStack {
                                    Image("profile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                   
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 10)
                            }
                            
                            .padding(.bottom, -10)
                        )
                }
            }
                    
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(.red)
                    .padding(.trailing, 10)
                Image(systemName: "message")
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                Image(systemName: "paperplane")
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                Spacer()
                Image(systemName: "bookmark")
                    .foregroundColor(.white)
            }
            .padding(.top, -35)
            .padding(.horizontal, 10)
            
            HStack {
                Text("\(post.likescount) likes")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            Text(post.descreption)
                .padding(.horizontal, 10)
                .padding(.top, 5)
            
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
