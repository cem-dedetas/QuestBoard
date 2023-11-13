//
//  AddProfilePhotoView.swift
//  test
//
//  Created by Cem Dedetas on 26.10.2023.
//

import SwiftUI

struct AddProfilePhotoView: View {
    @State var isImagePickerPresented:Bool = true
    @EnvironmentObject var authViewModel:AuthViewModel
    @StateObject var imageVM = ImageUploadViewModel()
    @State var selectedImages:[UIImage] = []
    @Binding var isAddPhotoPresented:Bool
    var body: some View {
        if imageVM.isLoading{
            ProgressView("Uploading...")
        }
        else{
            VStack{
                if (!selectedImages.isEmpty)
                    {
                        let selectedImage = selectedImages[0]
                    Spacer()
                        Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(alignment:.bottomTrailing){
                            Button{
                                selectedImages = []
                            } label :{
                                Image(systemName: "xmark")
                            }.foregroundStyle(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                    Spacer()
                    Button(){
                        selectedImages = []
                        isImagePickerPresented = true
                    } label : {
                        HStack{
                            Text("Change Image")
                            Image(systemName: "paperclip")
                        }
                    }.padding()
                    Button(){
                        imageVM.uploadedImages = selectedImages
                        imageVM.uploadImage{result in
                            switch(result){
                                case .success(let user ):
                                authViewModel.currentUser = user
                                    isAddPhotoPresented = false
                                case .failure(let error):
                                print(error.localizedDescription)
                            }
                            
                        }
                    } label : {
                        HStack{
                            Text("Use this image")
                        }.padding().background(Color.accentColor).clipShape(Capsule()).foregroundStyle(.white)
                    }
                }
                else{
                    Spacer()
                    //if user has photo already show it
                    Image(systemName: "camera.fill").resizable().scaledToFit().frame(height: 250).opacity(0.1)
                           
                        Spacer()
                    Button(){
                        selectedImages = []
                        isImagePickerPresented = true
                    } label : {
                        HStack{
                            Text("Select Image")
                            Image(systemName: "paperclip")
                        }
                    }
                }
            }.sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $selectedImages, maxSelectionCount: 1).ignoresSafeArea(.all)
            }
        }
    }
}
