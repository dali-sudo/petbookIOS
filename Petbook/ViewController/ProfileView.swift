    import SwiftUI

    struct ProfileView: View {
        @State private var selection: String? = nil
        @ObservedObject var viewModel: ProfileViewModel=ProfileViewModel()
        
        var body: some View {
            let defaults = UserDefaults.standard
            let username = defaults.string(forKey: "username") ?? "Jean Paul"
            let email = defaults.string(forKey: "email")
            let userId = defaults.string(forKey: "userId")
          
            NavigationView
            {
              
            VStack {
                NavigationLink(destination: EditProfileView(), tag: "EditUP", selection: $selection) { EmptyView() }
                NavigationLink(destination: LoginView(), tag: "SignIn", selection: $selection) { EmptyView() }
                NavigationLink(destination: PetViewPager(id :userId!), tag: "pets", selection: $selection) { EmptyView() }
                HStack {
                    
                    if let avatar = defaults.string(forKey:"avatar") {
                                                    
                        if let imageData = Data(base64Encoded: avatar) {                        
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image("Avatar")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            }
                        } else {
                            Image("Avatar")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                    }
                 
                 
                                            
                    VStack(alignment: .leading) {
                        NavigationLink(destination: UserProfileView()) { Text(username)
                            .fontWeight(.bold)}
                        
                        Button(action: {
                           
                            selection = "EditUP"
                            // handle edit button action
                        }) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
               
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom,20)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 25) {
                        ProfileCellView(imageName: "petIcon", name: "My pets", description: "Check on ur pets profiles", width: 70, height: 60)
                       
                      
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                }
                
             
                
             
                  Divider()
                    
                
                
                
                Spacer()
               
                    
                            Text("More")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal,20)
                             
                                
                                    VStack(spacing: 25) {
                          
                            ProfileCellView(imageName: "help", name: "Help & Support ", description: "Here u find how to use the app",width: 60, height: 50)
                            ProfileCellView(imageName: "logout 2", name: "Logout", description: "",width: 50, height: 50)
                            ProfileCellView(imageName: "", name: "About app", description: "Our Privacy Policy",width: 40, height: 40)
                          
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 100)
                    

                    
                    
                }
            
            }
                .navigationBarBackButtonHidden(true)
            }
        }

        struct ProfileCellView: View {
            var imageName: String
            var name: String
            var description: String
            var width : CGFloat
            var height : CGFloat
            var dest: String?
            
            var body: some View {
                let defaults = UserDefaults.standard
                let userId = defaults.string(forKey: "userId")
                NavigationLink(destination: PetViewPager( id: userId!)) {
                HStack {
                     
                    Image(imageName)
                        .resizable()
                        .frame(width: width, height: height)
                        .aspectRatio(contentMode: .fit)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(name)
                            .font(.headline)
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
            }
    }

    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
                
