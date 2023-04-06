//
//  PetProfileView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel=ProfileViewModel()
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = true
    
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
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("10")
                                .font(.headline)
                            Text("Posts")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(               String(viewModel.user!.user.followerscount)     )
                                .font(.headline)
                            Text("Followers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(String(viewModel.user!.user.followingcount))
                                .font(.headline)
                            Text("Following")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
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
                    
                    let id = defaults.string(forKey: "userId") ;
                    print(id!)
                    viewModel.getProfile(id:"63a8553948dccc27aba167de"){ result in
                   isLoading = false
                   switch result {
                   case .success(let u):
                     
                            
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
}
                

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
           UserProfileView()
    }
}

