//
//  PetProfileView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct UserProfileView: View {

        var body: some View {
            VStack {
                HStack {
                    VStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("@johndoe")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    
                    Spacer()
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("10")
                                .font(.headline)
                            Text("Posts")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text("123")
                                .font(.headline)
                            Text("Followers")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text("456")
                                .font(.headline)
                            Text("Following")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                .padding(.horizontal)
                
                Divider()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(0..<20) { _ in
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }

                

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
