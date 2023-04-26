import SwiftUI

struct Card: Identifiable, Decodable {
    let id: String
    let image: String
    let name: String
}

struct CardView: View {
    let pet: PetResponse
    @State var selection : String?
    let defaults = UserDefaults.standard
    var body: some View {
        NavigationLink(destination: PetProfileView().navigationBarBackButtonHidden(true), tag: "P", selection: $selection) { EmptyView() }
        VStack {
            if let petPic = pet.petPic {
                if let imageData = Data(base64Encoded: petPic),
                   let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipped()
                        .cornerRadius(20)
                }
            }
          
            if (pet.petName != nil)
            {
                Text(pet.petName!)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.black)
            }
         
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .onTapGesture {
            defaults.set(pet.id, forKey: "petId")
            print("clicked on" , pet.petName)
            selection = "P"
            
        }
    }
}

struct PetViewPager: View {
    @State private var showButton = false
    @State private var showFormSheet = false
    @State private var petName = ""
    @State private var petType = ""
    @State private var petRace = ""
    @State private var petSex = ""
    @State private var petBirthday = Date()
    @State private var avatarData: Data? = nil
    @ObservedObject var petViewModel = PetsViewModel()
    @State private var IsPickerShowing  = false
    @State private var image: UIImage? = nil
    @State private var showingNotification = false
    @State private var notificationText = ""
    var id: String
    let defaults = UserDefaults.standard
    
    
    var body: some View {
         
      
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            TabView {
                ForEach(petViewModel.OwnedPets) { card in
                    CardView(pet: card)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            if showButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showFormSheet = true
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            petViewModel.fetchCards(for: id)
            showButton = true
        }
        .sheet(isPresented: $showFormSheet, content: {
            NavigationView {
                Form{
                    Section(header: Text("Pet Information")) {
                        VStack {
                            TextField("Pet Name", text: $petName)
                                .padding()
                            TextField("Pet Type", text: $petType)
                                .padding()
                            TextField("Pet Race", text: $petRace)
                                .padding()
                            HStack {
                                Text("Pet Sex:")
                                Picker(selection: $petSex, label: Text("")) {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding()
                            DatePicker("Pet Birthday", selection: $petBirthday, displayedComponents: [.date])
                                .padding()
                        }
                        .padding()
                    }
                    
                    Section {
                     
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            IsPickerShowing = true;
                            // Add the pet
                        }, label: {
                            Text("Choose Avatar")
                        })
                            
                        
                      
                    }
                    
                    Section {
                      
                        Button(action: {
                            // Add the pet
                            print("sending request")
                            print(String(petName))
                           
                            petViewModel.addPet(owner : id,petName: petName, petType: petType, petRace: petRace, petSex: petSex, petBirthday: petBirthday, petAvatar: image)
                            { result in
                                        switch result {
                                        case .success(let petResponse):
                                            self.notificationText = "Pet added successfully"
                            showingNotification=true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                              self.showingNotification = false
                                                          }
                                            print("Pet added: \(petResponse)")
                                        case .failure(let error):
                                            print("Error adding pet: \(error)")
                                        }
                                    }



                           
                           
                        }, label: {
                            Text("Add Pet")
                        })
                    }
                }


                .navigationTitle("Add Pet")
                .navigationBarItems(trailing: Button(action: {
                    showFormSheet = false
                }, label: {
                    Text("Cancel")
                }))
            }
            .sheet(isPresented: $IsPickerShowing, onDismiss: nil)
            {
                ImagePicker(selectedImage: $image, isPicker: $IsPickerShowing)
            }
            .overlay(NotificationView(text: $notificationText, isShowing: $showingNotification), alignment: .top)
        })
    }
}

struct NotificationView: View {
    @Binding var text: String
    @Binding var isShowing: Bool

    var body: some View {
        Group {
            if isShowing {
                VStack {
                    Text(text)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .transition(.move(edge: .top))
            }
        }
    }
}

struct ViewPager_Previews: PreviewProvider {
    static var previews: some View {
        PetViewPager(id: "64222956e51b42f821d2f1ba")
    }
}
