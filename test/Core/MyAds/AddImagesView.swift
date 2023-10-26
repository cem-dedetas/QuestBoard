//
//  AddImagesView.swift
//  test
//
//  Created by Cem Dedetas on 8.10.2023.
//
import SwiftUI
import PhotosUI

struct AddImagesView: View {
    @State var advertId:String
    @State var advert:Advert? = nil
    @StateObject var imageVM = ImageUploadViewModel()
    @State var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    var columns = [
        GridItem(.flexible(minimum: 1, maximum: UIScreen.main.bounds.width/3 - 20), spacing: 20),
        GridItem(.flexible(minimum: 1, maximum: UIScreen.main.bounds.width/3 - 20), spacing: 20),
        GridItem(.flexible(minimum: 1, maximum: UIScreen.main.bounds.width/3 - 20), spacing: 20),
//        GridItem(.flexible(minimum: 1, maximum: UIScreen.main.bounds.width/4 - 10), spacing: 10)
    ]
    @Binding var stackIsActive:Bool
    
    var body: some View {
        VStack {
            if imageVM.isLoading {
                ProgressView("Uploading...")
            }
            else{
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width/3 - 20, height: UIScreen.main.bounds.width/3 - 20)
                                .cornerRadius(10)
                                .overlay(alignment:.topTrailing){
                                    Button{
                                        withAnimation(.easeInOut){
                                            selectedImages.removeAll(where: { im in
                                                im == image
                                            })
                                        }
                                    } label : {
                                        Image(systemName: "minus")
                                            .foregroundStyle(.white)
                                            .padding(10)
                                            .background(.red)
                                            .clipShape(Circle())
                                    }.offset(x:20,y:-10)
                                }
                        }
                        if selectedImages.count < 10 {
                            Button{
                                isImagePickerPresented = true
                            } label :{
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .tint(Color.secondary)
                                    .padding()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width/3 - 20, height: UIScreen.main.bounds.width/3 - 20)
                                    .background(.regularMaterial)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    
                    
                }
                Button{
                    imageVM.uploadedImages = selectedImages
                    imageVM.uploadImages(adId: advertId){result in
                        switch(result){
                            case .success(let advert):
                            self.advert = advert
                            stackIsActive.toggle()
                            case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                    }
                } label :{
                    HStack{
                        Text("Upload Images \(selectedImages.isEmpty ? "" : "(\(selectedImages.count))")")
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .disabled(selectedImages.count < 1)
                padding(.bottom, 50)
            }
            
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImages: $selectedImages)
        }
        .navigationTitle("Image Uploader")
        
    }
}

#Preview {
    AddImagesView(advertId:"",stackIsActive: .constant(true))
}
