//
//  SearchView.swift
//  Petbook
//
//  Created by user233432 on 4/26/23.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel:SearchUserViewModel = SearchUserViewModel()
  
    @State var list: [SearchResponse] = []
    @State private var isLoading: Bool = true
   
    @State private var text = ""
    private let searchDelay = 0.5 // Adjust this value as needed
    @State private var isEditing = false
    @State public  var  isNavigating = false
          
    var body: some View {
        VStack {
               TextField("Search", text: $text, onEditingChanged: { isEditing in
                   self.isEditing = isEditing
                   if !isEditing {
                       // Start a timer to delay the function call
                       Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                           self.search()
                       }
                   }
               })
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding()
            List {
                           ForEach(list.indices, id: \.self                             ) { index in
                               NavigationLink(destination: UserProfileView( userid: $list[index]._id)) {
                                   HStack{
                                      
                                                                       
                                       if let imageData = Data(base64Encoded: list[index].avatar!) {
                                               if let image = UIImage(data: imageData) {
                                                   Image(uiImage: image)
                                                       .resizable()
                                                       .frame(width: 20, height: 20)
                                                       .clipShape(Circle())
                                               } else {
                                                   Image("Avatar")
                                                       .resizable()
                                                       .frame(width: 80, height: 80)
                                                       .clipShape(Circle())
                                               }
                                           }
                                       
                                   Text(list[index].username)
                                       
                                   }
                               }
                           }
             
           }
        }.onChange(of: viewModel.SearchList) { newValue in
           // Refresh view when user profile changes
       }
    }
       func search() {
           print("Searching for \(text)...")
           viewModel.Search(SearchText: text){ result in
               isLoading = false
               switch result {
               case .success(let u):
                   
                   self.list = u
                   print(u)
                 // Handle successful sign-in
                   break
                   
                   
               case .failure(let error):
                   // Handle sign                      -in error
                   // showWrong = true
                   
                   print("get posts error error:", error)
                   
              
           }
           
           }
       }

}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        
    }
}
