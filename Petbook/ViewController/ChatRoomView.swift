//
//  ChatRoomView.swift
//  Petbook
//
//  Created by user233432 on 4/27/23.
//

import SwiftUI


struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isMe: Bool
}

struct ChatRoomView: View {
    @State private var newMessageText = ""
    @State private var messages = [
        Message(text: "Hello!", isMe: false),
        Message(text: "Hi there!", isMe: true),
        Message(text: "How are you?", isMe: false),
        Message(text: "I'm good, thanks!", isMe: true)
    ]
    @ObservedObject var viewModel: ChatViewModel=ChatViewModel()
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = true
    @State var id:String=""
    @Binding var chatId:String
    @State private var chats: [chat] = []
    var body: some View {
        VStack {
            HStack{
                Image("Avatar")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                   
                                                
                Text("username")
                Spacer()
            }
            if(chats != nil){

                ForEach(chats){ message in
                HStack {
                                            if message.senderid==id {
                                                if(message.type=="string"){
                                                    Spacer()
                                                    Text(message.message)
                                                        .padding(10)
                                                        .foregroundColor(.white)
                                                        .background(Color.orange)
                                                        .cornerRadius(10)
                                                } }else {
                                                    if(message.type=="string"){
                                                Text(message.message)
                                                    .padding(10)
                                                    .foregroundColor(.white)
                                                    .background(Color.gray)
                                                    .cornerRadius(10)
                                                Spacer()
                                                    } }
                }
            }
            }
            HStack {
                TextField("New message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    messages.append(Message(text: newMessageText, isMe: true))
                    newMessageText = ""
                }
            }
            .padding()
        }.onAppear{
let defaults = UserDefaults.standard
id = defaults.string(forKey: "userId")!
print("id"+chatId)

viewModel.getChat(id: chatId){ result in
    isLoading = false
    switch result {
    case .success(let u):
        chats=u.chat
        // Handle successful sign-in
        break
        
        
    case .failure(let error):
        // Handle sign                      -in error
        showWrong = true
        
        print("Sign-up error:", error)
        
    }
}
}      .onChange(of: viewModel.room) { newValue in
// Refresh view when user profile changes
}
        .navigationTitle("Chat")
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        let name = Binding.constant("");
        ChatRoomView( chatId:  name)
    }
}
