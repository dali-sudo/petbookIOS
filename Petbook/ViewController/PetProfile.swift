import SwiftUI

struct ImageInfo {
    let location: String
    let description: String
}

struct PetProfileView: View {
    
    let images: [ImageInfo] = [
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball"),
        ImageInfo(location: "help", description: "Cute cat playing with a ball")
       
    ]
    
    @State private var selectedImage: ImageInfo?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
                                    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                      .fill(Color.yellow)
                      .frame(height: 150)
                      .ignoresSafeArea()
                
                VStack {
                    Image("petIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                       
                    
                    
                    Text("MOMO")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                       
                }
            }
            
            
            Divider().background(Color.yellow)
                .padding(.top, 10)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(images.indices) { index in
                        Image(images[index].location)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 2)
                            .clipped()
                            .onTapGesture {
                                self.selectedImage = images[index]
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(maxHeight: .infinity)
                
            Spacer()
        }
        .overlay(
            Group {
                if selectedImage != nil {
                    VStack {
                        Image(selectedImage!.location)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        Text(selectedImage!.description)
                            .font(.headline)
                            .padding()
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Likes: 100")
                            Spacer()
                        }
                        .font(.subheadline)
                        .padding()
                        Spacer()
                    }
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onTapGesture {
                        self.selectedImage = nil
                    }
                    .padding(.horizontal, 20)
                }
            }
        )
    }
}

struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PetProfileView()
    }
}
