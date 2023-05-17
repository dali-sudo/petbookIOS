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
   
    var body: some View {
        NavigationView {
            ZStack{    if(isLoading){
                ProgressView()
            }
                else{
            VStack{
                
            
                if (viewModel.Posts != nil)  {
                    ScrollView
                    {
                      ForEach(viewModel.Posts!, id: \._id) { post in
                   PostView(post: post)
                        }
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
    @State private var hitTestDisabled = false
    @State var post: GetPostResponseData
    let defaults = UserDefaults.standard
    @State private var selection: String? = nil
    @State var isLiked = false
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
                            var body: some View {
                                VStack() {
                                    NavigationLink(destination: PetProfileView(), tag: "P", selection: $selection) { EmptyView() }
                                    if (post.owner != nil )
                                    {
                                        Text(post.owner!.username)
                                    }
                                   
                                       
                                       
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
                                                if isLiked {
                                                    dislike()
                                                    print("unliked")
                                                } else {
                                                    like()
                                                    print("liked")
                                                }
                                                self.hitTestDisabled = true // Disable hit testing
                                                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                           self.hitTestDisabled = false
                                                
                                            }
                                            }) {
                                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                                    .foregroundColor(isLiked ? .red : .gray)
                                                    .frame(width: 20, height: 20)
                                            }
                                             
                                    
                                    HStack {
                                        Text("\(post.likescount) likes")
                                            .fontWeight(.bold)
                                            .padding(.leading,  25)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.top, 10)
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack(spacing: 10) {
                                            ForEach(post.tags!, id: \._id) { pet in
                                               
                                                    Text(pet.name)
                                                        .foregroundColor(Color.white )
                                                        .padding(.horizontal, 10)
                                                        .padding(.vertical, 5)
                                                        .background(Color.gray)
                                                        .cornerRadius(20)
                                                
                                                        .onTapGesture {
                                                            print(pet._id)
                                                            defaults.set(pet._id, forKey: "petId")
                                                            selection = "P"
                                                        }
                                                
                                            }
                                        }
                                        .padding(.leading, 25)
                                    
                                    Text(post.descreption)
                                        .padding(.horizontal, 10)
                                        .padding(.top, 5)
                                    
                                    Spacer()
                                    }   }.onAppear{
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
                                .allowsHitTesting(!hitTestDisabled)
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

