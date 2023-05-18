//
//  ChatRoomView.swift
//  Petbook
//
//  Created by user233432 on 4/27/23.
//

import SwiftUI
import SocketIO

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
    @Binding var avatar:String
    @Binding var chatName:String
    @State private var tempSelectedImage: UIImage? = nil
    @State private var chats: [chat] = []
    @State private var selectedImage: UIImage?
    @State private var IsPickerShowing  = false
    let socketIOManager = SocketIOManager()
    @State private var shouldScrollToBottom = true
    var body: some View {
        VStack {
            if(isLoading){
                ProgressView()
            }
            else{
            HStack{
                if let uiImage = UIImage(data: Data(base64Encoded:
                                             avatar      ) ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 60, height: 60) .clipShape(Circle()).aspectRatio(contentMode: .fill)
                }
                    
                if(viewModel.room != nil){
                Text(chatName)
                Spacer()
                }
            }
            if(chats != nil){
                ScrollViewReader             { proxy   in
                List(chats, id: \._id){ message in
                HStack {
                                            if message.senderid==id { Spacer()
                                                if(message.type=="string"){
                                                   
                                                    Text(message.message)
                                                        .padding(10)
                                                        .foregroundColor(.white)
                                                        .background(Color.orange)
                                                        .cornerRadius(10)
                                                }
                                                else{
                                                    if let uiImage = UIImage(data: Data(base64Encoded:
                                                                                            message.message     ) ?? Data()) {
                                                        Image(uiImage: uiImage)
                                                            .resizable() 
                                                            .frame(width: 200, height: 200)                            .clipShape(Rectangle()).aspectRatio(contentMode: .fill)
                                                    }
                                                }
                                            }else {
                                                    if(message.type=="string"){
                                                Text(message.message)
                                                    .padding(10)
                                                    .foregroundColor(.white)
                                                    .background(Color.gray)
                                                    .cornerRadius(10)
                                              
                                                    }
                                                else{
                                                    if let uiImage = UIImage(data: Data(base64Encoded:
                                                                                            message.message     ) ?? Data()) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .frame(width: 200, height: 200)                            .clipShape(Rectangle()).aspectRatio(contentMode: .fill)
                                                    }
                                                }
                                                Spacer()
                                            }
                }
            } .listStyle(PlainListStyle())
                    .onChange(of: chats) { _ in
                        proxy.scrollTo(chats.count-1)
                    }
                    .onAppear {
                    
                            proxy.scrollTo(chats.count-1)
                                           
                    }
                }
                
            
            }
            HStack {
                TextField("New message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    IsPickerShowing = true  
                  }) {
                      Image(systemName: "photo")
                          .foregroundColor(.orange)
                  }
                Button("Send") {
                   sendMessage()
                    newMessageText = ""
                }
                
            }
            .padding()
            }
        }.navigationTitle("Chat")
            .onAppear{
let defaults = UserDefaults.standard
id = defaults.string(forKey: "userId")!
print("id"+chatId)
                
                                   
                    
                socketIOManager.start(
                    onConnect: {
                        socketIOManager.config(id: id)
                    },
                    onReady: {
                        viewModel.refresh(s: socketIOManager.socket, id: chatId)                    }
                )
                
            
                
             
                
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
print("change")
    chats=newValue!.chat
}.onDisappear {
    self.socketIOManager.socket.disconnect()
}                            .sheet(isPresented: $IsPickerShowing ) {
    ImagePicker(selectedImage: $tempSelectedImage, isPicker: $IsPickerShowing )
        .onDisappear {
            if let image = tempSelectedImage {
            sendimage()
                tempSelectedImage = nil
            }
        }
        .onAppear {
           
            tempSelectedImage = selectedImage
        }
    }
    }
   func sendMessage(){
       if(newMessageText != ""){

       viewModel.sendMsg(id: chatId, message:newMessageText, type: "string", senderid: id){ result in
           isLoading = false
           
           switch result {
           case .success(let u):
               for chat in viewModel.room!.Users {
                   if chat._id != id {
                       print("mine"+id)
                       print("to"+chatId)
                       self.socketIOManager.socket.emit("send", chat._id)
                   } }
               chats=u.chat
              
               newMessageText = ""
               break
               
               
           case .failure(let error):
               // Handle sign                      -in error
               showWrong = true
               
               print("Sign-up error:", error)
               
           }
       }
      
    }
   }
    func sendimage(){
        print("image")
        if tempSelectedImage != nil {
            if let imageData = tempSelectedImage!.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString(options: [])
                viewModel.sendMsg(id: chatId, message:base64String, type: "image", senderid: id){ result in
                    isLoading = false
                    switch result {
                    case .success(let u):
                        for chat in viewModel.room!.Users {
                            if chat._id != id {
                                print("mine"+id)
                                print("to"+chatId)
                                self.socketIOManager.socket.emit("send", chat._id)
                            } }
                        chats=u.chat
                        newMessageText = ""
                        break
                        
                        
                    case .failure(let error):
                        // Handle sign                      -in error
                        showWrong = true
                        
                        print("Sign-up error:", error)
                        
                    }
                }
                
            }
        } }
  }
struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        let name = Binding.constant("");
        ChatRoomView( chatId:  name,avatar: name,chatName: name)
    }
}
