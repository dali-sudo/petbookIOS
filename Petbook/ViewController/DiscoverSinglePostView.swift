//
//  DiscoverSinglePostView.swift
//  Petbook
//
//  Created by user233432 on 5/18/23.
//

import SwiftUI

struct DiscoverSinglePostView: View {
    
        @State private var hitTestDisabled = false
    @State var post: GetPostResponseData?
    @State var postid:String
        let defaults = UserDefaults.standard
        @State private var selection: String? = nil
        @State var isLiked = false
    @State var condition = false
        @State var profileid = ""
        @ObservedObject var viewModel: GetPostsViewModel=GetPostsViewModel()
    @State private var isLoading: Bool = true
   
    

                                var body: some View {
                                    NavigationLink(destination: UserProfileView(userid: $profileid ), isActive: $condition) {
                                        EmptyView()
                                    }
                                    .hidden()
                                    ZStack{    if(isLoading){
                                        ProgressView()
                                    }
                                        else{
                                           
                                            VStack(alignment: .leading, spacing: 16) {
                                              
                                                HStack{
                                                    
                                                    Button(action: {
                                                        profileid=(post?.owner!._id)!
                                                        condition=true
                                                    }) {
                                                        if let imageData = Data(base64Encoded: (post?.owner?.avatar!)!) {
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
                                                    }
                                                    Button(action: {
                                                        profileid=(post?.owner!._id)!
                                                        condition=true
                                                    }) {
                                                        Text((post?.owner!.username)!)
                                                    }
                                                    Spacer()
                                                    
                                                    Image(systemName: "ellipsis")
                                                        .font(.headline)
                                                }
                                                .padding(.horizontal)
                                                
                                                if post?.images!.count != 0
                                                {
                                                    ScrollView(.horizontal, showsIndicators: false) {
                                                        HStack(spacing: 10) {
                                                            ForEach((post?.images!)!, id: \.self) { image in
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
                                                    Text("\(post!.likescount) likes")
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                        .padding(.leading, 10)
                                                    Spacer()
                                                }
                                                
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 10) {
                                                        ForEach(post?.tags ?? [], id: \._id) { pet in
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
                                                
                                                Text(post!.descreption)
                                                    .font(.body)
                                                    .padding(.horizontal, 10)
                                                    .padding(.top, 5)
                                                
                                                Spacer()
                                                
                                            }}       }.onAppear{
                                        let defaults = UserDefaults.standard
                                        let userid = defaults.string(forKey: "userId")!
                                        viewModel.getSinglePost(postid:postid ){ result in
                                            isLoading = false
                                            switch result {
                                            case .success(let u):
                                            post=u
                                                if let array = post?.likes {
                                                    for i in    array                   {
                                                        if i == userid {
                                                            isLiked=true
                                                            break // exit the loop once the ID is found
                                                        }
                                                    }
                                                }
                                                isLoading=false
                                                // Handle successful sign-in
                                                break
                                                
                                                
                                            case .failure(let error):
                                                // Handle sign                      -in error
                                                // showWrong = true
                                                
                                                print("get posts error error:", error)
                                                
                                            }
                                            
                                            
                                            
                                           
                                            
                                        }}.onChange(of: viewModel.SinglePost) { newValue in
                                        // Refresh view when user profile changes
                                    }
                                    
                                    }
        private func like(){
            let defaults = UserDefaults.standard
            let userid = defaults.string(forKey: "userId")!
            viewModel.like(id: post!._id,like:userid){ result in
           switch result {
           case .success(let u):
           isLiked=true
               post!.likescount+=1
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
            viewModel.dislike(id: post!._id,like:userid){ result in
           switch result {
           case .success(let u):
           isLiked=false
               post!.likescount-=1
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


