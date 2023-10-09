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
    
    @Binding var stackIsActive:Bool
    
    var body: some View {
        VStack {
            if imageVM.isLoading {
                ProgressView("Uploading...")
            }
            else{
                
            
                Button("Select Images") {
                    isImagePickerPresented = true
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 500), spacing: 10)], spacing: 10) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    Button("Upload Images") {
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
                    }
                }
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
