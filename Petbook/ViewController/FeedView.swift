//
//  FeedView.swift
//  Petbook
//
//  Created by user233432 on 4/5/23.
//

import SwiftUI
struct Post: Identifiable {
    var id = UUID()
    var username: String
    var postImage: String
    var likes: Int
    var caption: String
}
struct FeedView: View {
    let posts = [
           Post(username: "johndoe", postImage: "post1", likes: 103, caption: "Beautiful view from my window."),
           Post(username: "janedoe", postImage: "post2", likes: 232, caption: "Spent the weekend hiking with my dog."),
           Post(username: "johndoe", postImage: "post3", likes: 527, caption: "Best meal I've had in a while!"),
           Post(username: "janedoe", postImage: "post4", likes: 387, caption: "Just finished reading this book and it was amazing."),
           Post(username: "johndoe", postImage: "post5", likes: 198, caption: "Celebrating my birthday with my friends."),
           Post(username: "janedoe", postImage: "post6", likes: 467, caption: "Finally finished this painting after weeks of work."),
       ]
    var body: some View {
           NavigationView {
               List(posts) { post in
                   VStack(alignment: .leading) {
                       HStack {
                           Image("profile")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .clipShape(Circle())
                               .frame(width: 40, height: 40)
                           
                           Text(post.username)
                               .fontWeight(.bold)
                           
                           Spacer()
                           
                           Image(systemName: "ellipsis")
                       }
                       .padding(.horizontal, 10)
                       
                       Image(post.postImage)
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(height: 300)
                       
                       HStack {
                           Image(systemName: "heart.fill")
                               .foregroundColor(.red)
                           
                           Text("\(post.likes) likes")
                           
                           Spacer()
                       }
                       .padding(.horizontal, 10)
                       
                       Text(post.caption)
                           .padding(.horizontal, 10)
                           .padding(.bottom, 10)
                   }
               }
               .navigationBarTitle("PetBook")
           }
       }
   }
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
