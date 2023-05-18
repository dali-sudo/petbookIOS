import SwiftUI

struct ImageInfo {
    var location: UIImage?
    let description: String?
}

struct PetProfileView: View {
    
    @StateObject var viewModel = PetsViewModel()
    @State var images: [UIImage] = []
    @State private var selectedImage: ImageInfo?
    @State var petAvatar : String?
    @State var petName : String?
    @State var petType : String?
    @State var petRace : String?
    @State var isLoading = true
    let defaults = UserDefaults.standard
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
                                    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                      .fill(Color.yellow)
                      .frame(height: 150)
                      .ignoresSafeArea()
                     
                
                VStack {
                    if petAvatar != nil {
                        if let imageData = Data(base64Encoded: petAvatar!),
                           let uiImage = UIImage(data: imageData)
                        {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding(.top,100)
                              
                        }
                    } else {
                        Image("petIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.top,100)
                           
                    }
                    
                    if petName != nil {
                        Text(petName!)
                            .font(.title)
                            .foregroundColor(.black)
                        if  petRace != nil && petType != nil {
                            Text("\(petRace!) \(petType!)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    } else {
                        Text("Undefined")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    // Other content if any
                }
                
               

            }
            
            
            Divider().background(Color.yellow)
                .padding(.top, 10)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 2)
                                .clipped()
                                .onTapGesture {
                                    // handle image tap
                                    print("clicked")
                                    self.selectedImage = ImageInfo(location: image, description: "jajaaja")
                                  
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .frame(maxHeight: .infinity)
            }
                
            Spacer()
        }
       
        .ignoresSafeArea()
        .overlay(
            Group {
                if selectedImage != nil {
                    VStack {
                        Image(uiImage:selectedImage!.location!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                       /*
                        Text("gfdg")
                            .font(.headline)
                            .padding()
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Likes: 100")
                            Spacer()
                        }
                       
                        .font(.subheadline)
                        .padding()
                        Spacer()
                        */
                    }
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onTapGesture {
                        self.selectedImage = nil
                    }
                    .padding(.horizontal, 20)
                }
            }
        )
        .onAppear {
           let id = defaults.object(forKey: "petId")! as! String
            viewModel.getPetImages(id: id) { (uiImages) in
                            self.images = uiImages
                            isLoading = false
                            print(images.count)
                        }
            viewModel.getPetProfile(petId: id) { result in
                switch result {
                case .success(let pet):
                    if (pet.type != nil)
                    {
                        petType = pet.type!
                    }
                    if (pet.race != nil)
                    {
                        petRace = pet.race!
                    }
                    if (pet.name != nil)
                    {
                        petName = pet.name!
                    }
                   
                    if(pet.avatar != nil)
                    {
                        petAvatar = pet.avatar!
                    }
                case .failure(let error):
                    print("Error fetching pet details: \(error.localizedDescription)")
                }
            }
        }
    }
}
        
/*
 struct PetProfileView_Previews: PreviewProvider {
 static var previews: some View {
 PetProfileView()
 }
 }
 */
