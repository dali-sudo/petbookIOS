import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack {
                Image("Avatar")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
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
}

struct ProfileCellView: View {
    var imageName: String
    var name: String
    var description: String
    var width : CGFloat
    var height : CGFloat
    
    var body: some View {
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}