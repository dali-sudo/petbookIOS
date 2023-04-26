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
    let posts = [        Pos(username: "user1", postImage: "post1"),        Pos(username: "user2", postImage: "post2"),        Pos(username: "user3", postImage: "post3"),        Pos(username: "user4", postImage: "post4")    ]

    var body: some View {
        NavigationView {
            List(posts) { post in
                NavigationLink(destination: ChatRoomView())  {
                    HStack() {
                        
                        Image("Avatar")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        VStack{
                            Text(post.username)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.leading, -20)
                            
                            Text("last message")
                                .padding(.leading, 10)
                            
                        }; Spacer()
                    }}
            }
            .navigationBarTitle("PetBook                    ")
        }
    }
}


struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
