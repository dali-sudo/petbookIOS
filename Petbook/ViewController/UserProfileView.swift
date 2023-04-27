//
//  PetProfileView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct UserProfileView: View {
    @Binding  var userid:String
    @ObservedObject var viewModel: ProfileViewModel=ProfileViewModel()
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = true
    @State var id:String=""
    @State var followsCount: Int = 0

    @State private var isFollowing:Bool=false
 
    var body: some View {
            VStack {
                if(isLoading){
                    ProgressView()
                }
                else{
                    
                
                            HStack {
                                VStack{ if let uiImage = UIImage(data: Data(base64Encoded: viewModel.user!.user.avatar) ?? Data()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 80, height: 80) .clipShape(Circle()).aspectRatio(contentMode: .fill)
                        VStack(alignment: .leading) {       
                            Text( viewModel.user!.user.username)
                                .font(.headline)
                         
                        }
                        
                    }
                    }
                                ;         Spacer()
                                VStack{
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text(String(viewModel.user!.posts.count))
                                .font(.headline)
                                .padding(.leading,5)
                            Text("Posts")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(String(followsCount))
                                .font(.headline)
                                .padding(.leading,5)
                            Text("Followers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(String(viewModel.user!.user.followingcount))
                                .font(.headline)
                                .padding(.leading,5)                        
                            Text("Following")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                                    HStack {
                                        if id != userid {
                                                    Button("Message") {
                                                        // Handle message button tap
                                                    }
                                                    .padding(6)
                                                           .background(Color.yellow)
                                                           .foregroundColor(Color.white)
                                                           .clipShape(RoundedRectangle(cornerRadius: 10))
                                               
                                                Button(isFollowing ? "Unfollow" : "Follow") {
                                                    if isFollowing {
                                                        print("unfollow")
                                                    Unfollow()
                                                        
                                                    }
                                                    else{
                                                        follow()}                                                   
                                                    isFollowing.toggle()
                                                }
                                                .padding(6          )
                                                       .background(Color.yellow)
                                                       .foregroundColor(Color.white)
                                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                    }
                }
                               
                            }
                .padding(6)
                
                .padding(.horizontal)
                
                Divider()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                     ForEach(viewModel.user!.posts, id: \.self) { post in
                                if let uiImage = UIImage(data: Data(base64Encoded: post.images[0]) ?? Data()) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }                    .padding()
                }
                Spacer()
            }
                } } .onAppear{
                    let defaults = UserDefaults.standard
                    id = defaults.string(forKey: "userId")!
                    print("id"+id)
                    print("userid"+userid)
                    viewModel.getProfile(id:userid){ result in
                   isLoading = false
                   switch result {
                   case .success(let u):
                       followsCount=(viewModel.user?.user.followerscount)!
                       if let array = viewModel.user?.user               .followers {
                       for i in    array                   {
                           if i == id {
                           isFollowing=true
                               break // exit the loop once the ID is found
                           }
                       }
                       }
                       // Handle successful sign-in
                      break
                             
                   
                   case .failure(let error):
                       // Handle sign                      -in error
                       showWrong = true
                    
                       print("Sign-up error:", error)
                     
                   }
               }
                }      .onChange(of: viewModel.user) { newValue in
                    // Refresh view when user profile changes
                }         }
    private func follow(){
        viewModel.Follow(myid:id,followed:userid){ result in
     
       switch result {
       case .success(let u):
         
           followsCount = followsCount + 1
           // Handle successful sign-in
          break
       isFollowing=true
       
       case .failure(let error):
           // Handle sign                      -in error
           showWrong = true
        
           print("Sign-up error:", error)
         
       }
   }
    }
    private func Unfollow(){
        viewModel.UnFollow(myid:id,followed:userid){ result in
     
       switch result {
       case .success(let u):
         
           followsCount = followsCount - 1
           // Handle successful sign-in
          break
       isFollowing=false
       
       case .failure(let error):
           // Handle sign                      -in error
           showWrong = true
        
           print("Sign-up error:", error)
         
       }
   }
    }
}
                

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let name = Binding.constant("John");        UserProfileView(userid: name)
    }
}

