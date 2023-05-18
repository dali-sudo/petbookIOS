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
                    { VStack(spacing: 0)
                        {
                            PullToRefreshView { refresh() }
                            ForEach(viewModel.Posts!, id: \._id) { post in
                         PostView(post: post)
                            // ScrollView content
                        }
                    
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
    private func refresh(){
       print("refresh")
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
@State var condition = false
    @State var profileid = ""
    @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
                            var body: some View {
                                NavigationLink(destination: UserProfileView(userid: $profileid ), isActive: $condition) {
                                    EmptyView()
                                }
                                .hidden()
                                VStack(alignment: .leading, spacing: 16) {
                                 
                                                  HStack{
                                                     
                                                      Button(action: {
                                                          profileid=post.owner!._id
                                                          condition=true
                                                      }) {
                                                          if(post.owner?.avatar != nil){
                                                              if let imageData = Data(base64Encoded: (post.owner?.avatar!)!) {
                                                                  if let image = UIImage(data: imageData) {
                                                                      Image(uiImage: image)
                                                                          .resizable()
                                                                          .frame(width: 50, height: 50)
                                                                          .clipShape(Circle())
                                                                  } else {
                                                                      Image("Avatar")
                                                                          .resizable()
                                                                          .frame(width: 80, height: 80)
                                                                          .clipShape(Circle())
                                                                  }
                                                              }
                                                          }}
                                                      Button(action: {
                                                          if ((post.owner?._id) != nil)
                                                          {
                                                              profileid=post.owner!._id
                                                              condition=true
                                                          }
                                                         
                                                        
                                                      }) {
                                                          if let postOwner = post.owner {
                                                              Text(postOwner.username )}
                                                              // Use the username variable
                                                     
                                                      else {
                                                          Text("username")  // Handle the case when post.owner is nil
                                                              // You can provide a default value or display an error message
                                                          }
                                                      }
                                                      
                                              Spacer()
                                              
                                              Image(systemName: "ellipsis")
                                                  .font(.headline)
                                          }
                                          .padding(.horizontal)
                                    Text(post.descreption)
                                              .font(.body)
                                              .padding(.horizontal, 10)
                                            
                                    if post.images!.count != 0
                                    {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 10) {
                                                        ForEach(post.images!, id: \.self) { image in
                                                            if let postImages = image, let imageData = Data(base64Encoded: image), let image = UIImage(data: imageData) {
                                                                Image(uiImage: image)
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: UIScreen.main.bounds.width - 32)
                                                                    .padding(.leading,16)
                                                                   
                                                        }
                                                    }
                                                }
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
                                                  .frame(width: 30, height: 30)
                                          }
                                          
                                          HStack {
                                              Text("\(post.likescount) likes")
                                                  .font(.headline)
                                                  .fontWeight(.bold)
                                                  .padding(.leading, 10)
                                              Spacer()
                                          }
                                          
                                          ScrollView(.horizontal, showsIndicators: false) {
                                              HStack(spacing: 10) {
                                                  ForEach(post.tags ?? [], id: \._id) { pet in
                                                      Text(pet.name)
                                                          .foregroundColor(.white)
                                                          .font(.caption)
                                                          .padding(.horizontal, 12)
                                                          .padding(.vertical, 6)
                                                          .background(Color.gray)
                                                          .cornerRadius(20)
                                                          .onTapGesture {
                                                              print(pet._id)
                                                              defaults.set(pet._id, forKey: "petId")
                                                              selection = "P"
                                                          }
                                                  }
                                              }
                                              .padding(.leading, 10)
                                          }
                                          
                                   
                                          
                                          Spacer()
                                      
                                  }.onAppear{
                                    let defaults = UserDefaults.standard
                                      var userid=""
                                      if defaults.string(forKey: "userId") != nil{
                                 
                                    userid = defaults.string(forKey: "userId")!
                                      }
                                      
                                      
                                    if let array = post.likes {
                                    for i in    array   {
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
        
           print("like error error:", error)
         
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

