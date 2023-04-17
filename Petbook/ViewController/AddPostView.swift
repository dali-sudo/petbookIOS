//
//  AddPostView.swift
//  Petbook
//
//  Created by bokh on 12/4/2023.
//

import SwiftUI

struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel:AddPostViewModel = AddPostViewModel()
    @State private var postText = ""
    @State private var selectedImage: UIImage?
    @State private var IsPickerShowing  = false
    @State private var images: [UIImage] = []
    @State private var simage: UIImage? = nil
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var currentIndex = 0
    @State private var isLoading: Bool = false
    @State private var tempSelectedImage: UIImage? = nil
    @State private var showsucces  = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @ObservedObject var petViewModel = PetsViewModel()
    @State private var selectedPetId: String?
    @State private var selectedPetIds: [String] = []
    var body: some View {
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "userId") ;
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
              
                if images.count != 0
                {
                    ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(images, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            }
                }
                Button(action: {
                
                    IsPickerShowing = true  // Show image picker
                }) {
                    Text("Add Photo")
                        
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Write your post")
                        .font(.headline)
                    TextEditor(text: $postText)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                HStack(spacing: 10) {
                                    Text("Select a pet:")
                                        .font(.headline)
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack(spacing: 10) {
                                            ForEach(petViewModel.OwnedPets, id: \.id) { pet in
                                                Button(action: {
                                                    if selectedPetIds.contains(pet.id!) {
                                                                       selectedPetIds.removeAll { $0 == pet.id }
                                                        print(selectedPetIds)
                                                                   } else {
                                                                       selectedPetIds.append(pet.id!)
                                                                       print(selectedPetIds)
                                                                   }
                                                               }){
                                                    Text(pet.petName!                       )
                                                        .foregroundColor(selectedPetId == pet.id ? .white : .black)
                                                        .padding(.horizontal, 10)
                                                        .padding(.vertical, 5)
                                                        .background(selectedPetIds.contains(pet.id!) ? Color.blue : Color.gray)
                                                        .cornerRadius(20)
                                                }
                                            }
                                        }
                                    }
                                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Post", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    },
                trailing:
                    Button(action: {
                       
                            isLoading = true
                            viewModel.AddPost(owner: "63a8553948dccc27aba167de", descreption:postText, images: images,petIds: selectedPetIds) { result in
                                isLoading = false
                                switch result {
                                case .success(let user):
                                    alertMessage = "Post Created!"
                                    alertTitle = "Success"    ;                           showsucces = true
                            case .failure(let error):
                                    // Handle sign
                                    alertMessage = "Error"
                                    alertTitle = "Error"    ;                           showsucces = true
                                }
                            }
                        
                        
                        
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        else {
                            Text("Post")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                    .disabled(postText.isEmpty)
            )
        }.onAppear {
            print("appear")
            petViewModel.fetchCards(for: id!)
           
        }.sheet(isPresented: $IsPickerShowing ) {
            ImagePicker(selectedImage: $tempSelectedImage, isPicker: $IsPickerShowing )
                .onDisappear {
                    if let image = tempSelectedImage {
                        images.append(image)
                        tempSelectedImage = nil
                    }
                }
                .onAppear {
                   
                    tempSelectedImage = selectedImage
                }
        }.alert(isPresented: $showsucces) {
            Alert(title: Text(alertTitle), message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    
    }
}


struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
