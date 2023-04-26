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
                
            
                if (viewModel.Posts != nil)  {
                    List(viewModel.Posts!, id: \._id) { post in
               PostView(post: post)
                    }
    .navigationBarTitle("PetBook")
                }
                              
               
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
    
    @State var post: GetPostResponseData
    let defaults = UserDefaults.standard
    @State private var selection: String? = nil
    @State var isLiked = false
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
    var body: some View {
        VStack(alignment: .leading) {
           // NavigationLink(destination: PetProfileView(), tag: "P", selection: $selection) { EmptyView() }
            Text(post.owner!.username)
               
               
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
                    
          
                Button(action: {
                    if isLiked{
                    dislike()
                        print("unliked")
                    }
                    else{
                        like()
                            print("liked")
                    }
                      }) {
                          Image(systemName: isLiked ? "heart.fill" : "heart")
                              .foregroundColor(isLiked ? .red : .gray)
                             
                          .frame(width:5 , height:5)                      }
                      
    
            HStack {
                Text("\(post.likescount) likes")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(post.tags!, id: \.id) { pet in
                        Button(action: {
                            // GET HIM TO PETS PROFILE AND LOAD THE DATA OFTH EPET  THERE
                            //  selection = "p"
                            defaults.set(pet.id, forKey: "petId")
                            
                        }){
                            Text(pet.name)
                                .foregroundColor(Color.white )
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            Text(post.descreption)
                .padding(.horizontal, 10)
                .padding(.top, 5)
            
            Spacer()
        }.onAppear{
            let defaults = UserDefaults.standard
            let userid = defaults.string(forKey: "userId")!
            if let array = post.likes {
            for i in    array                   {
                if i == userid {
                isLiked=true
                    break // exit the loop once the ID is found
                }
            }
            }
            
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .allowsHitTesting(false)
    }
    private func like(){
        let defaults = UserDefaults.standard
        let userid = defaults.string(forKey: "userId")!
        viewModel.like(id: post._id,like:userid){ result in
       switch result {
       case .success(let u):
       isLiked=true
           post.likescount+=1
           // Handle successful sign-in
          break
                 
       
       case .failure(let error):
           // Handle sign                      -in error
          // showWrong = true
        
           print("get posts error error:", error)
         
       }
   }
    }
    private func dislike(){
        let defaults = UserDefaults.standard
        let userid = defaults.string(forKey: "userId")!
        viewModel.dislike(id: post._id,like:userid){ result in
       switch result {
       case .success(let u):
       isLiked=false
           post.likescount-=1
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
