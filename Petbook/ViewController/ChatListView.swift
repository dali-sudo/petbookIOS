//
//  ChatListView.swift
//  Petbook
//
//  Created by user233432 on 4/27/23.
//

import SwiftUI

struct Pos: Identifiable {
    var id = UUID()
    var username: String
    var postImage: String
}

struct ChatListView: View {
    
    @ObservedObject var viewModel: ChatViewModel=ChatViewModel()
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = true
    @State var id:String=""
    @State var selectedChatId: String = ""
    @State var contacts:[GetPostsViewModel]?
    var body: some View {
        NavigationView {
            if(viewModel.contacts != nil){
                        List(viewModel.contacts!, id: \._id) { c in
                            NavigationLink(destination: ChatRoomView(chatId:$selectedChatId))  {
                    HStack() {
                        
                        if let uiImage = UIImage(data: Data(base64Encoded: c.Users[0].avatar) ?? Data()) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 40, height: 40) .clipShape(Circle()).aspectRatio(contentMode: .fill)
                        }
                            
                            VStack{
                                Text(c.Users[0].username)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    
                                
                                //  Text("last message")
                                //.padding(.leading, 10)
                                
                            }; Spacer()
                        }} .onTapGesture {
                            print("selected")
                            print("chatid"+c._id)
                            selectedChatId = c._id
                        }
                }                }
        }
        .navigationBarTitle("PetBook ")
                            .onAppear{
                let defaults = UserDefaults.standard
                id = defaults.string(forKey: "userId")!
                print("id"+id)
                
                viewModel.getContacts(id: id){ result in
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
            }      .onChange(of: viewModel.contacts) { newValue in
                // Refresh view when user profile changes
            }             }
    }

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
