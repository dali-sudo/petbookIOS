    import SwiftUI

    struct ProfileView: View {
        @State var userId :String = ""
        @State private var selection: String? = nil
        @ObservedObject var viewModel: ProfileViewModel=ProfileViewModel()
        
        var body: some View {
            let defaults = UserDefaults.standard
            let username = defaults.string(forKey: "username") ?? "Jean Paul"
            let email = defaults.string(forKey: "email")
          
            NavigationView
            {
              
            VStack {
                NavigationLink(destination: EditProfileView(), tag: "EditUP", selection: $selection) { EmptyView() }
                NavigationLink(destination: LoginView(), tag: "SignIn", selection: $selection) { EmptyView() }
                NavigationLink(destination: PetViewPager(id :userId), tag: "pets", selection: $selection) { EmptyView() }
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
                       
                        NavigationLink(destination: UserProfileView(userid: $userId)) { Text(username)
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
                    VStack(spacing: 0) {
                        ProfileCellView(imageName: "petIcon", name: "My pets", description: "Check on ur pets profiles", width: 70, height: 60, dest: "pets")
                       
                      
                    }
                    .padding(.horizontal, 20)
            
                    
                }
                
             
                
             
                  Divider()
                    
                
                
                
                Spacer()
               
                    
                            Text("More")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal,20)
                             
                                
                                    VStack(spacing: 10) {
                          
                            
                            ProfileCellView(imageName: "logout 2", name: "Logout", description: "",width: 50, height: 50, dest: "SignIn", isLogout: true)
                            ProfileCellView(imageName: "help", name: "About app", description: "Our Privacy Policy",width: 40, height: 40)
                          
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                    

                    
                    
                }
            
            }.onAppear(){
                userId = defaults.string(forKey: "userId")!

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
            var isLogout : Bool? = false
            @State private var selection: String? = nil
            
            
            var body: some View {
                
              
                
                let defaults = UserDefaults.standard
                let userId = defaults.string(forKey: "userId")
                
                    
                    if (userId != nil)
              
                    {
                        NavigationLink(destination: PetViewPager(id :userId!), tag: "pets", selection: $selection) { EmptyView() }
                        
                    }
                
                                                    
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
                .onTapGesture {
                    print("clicked")
                    if (isLogout!) {
                        defaults.removeObject(forKey: "userId")
                       
                        
                    }
                    if (dest != nil) {
                        selection = dest
                    }
                }
            }
            
    }

    
                
