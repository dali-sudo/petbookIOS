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
            List(messages) { message in
                HStack {
                    if message.isMe {
                        Spacer()
                        Text(message.text)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(10)
                    } else {
                        Text(message.text)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                        Spacer()
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
        }
        .navigationTitle("Chat")
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}
