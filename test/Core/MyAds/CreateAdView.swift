//
//  CreateAdView.swift
//  test
//
//  Created by Cem Dedetas on 30.09.2023.
//
import Combine
import SwiftUI
import iPhoneNumberField
import MapKit


struct UploadResponse: Decodable {
    let message: String
    let stack: String
}

struct CreateAdView: View {
    
    @StateObject var advertViewModel = SingleAdvertViewModel()
    @StateObject var imageViewModel = ImageUploadViewModel()
    
    var advertIDPublisher: AnyPublisher<String, Never> {
                NotificationCenter.default.publisher(for: Notification.Name("AdvertIDReceived"))
                    .compactMap { $0.object as? String }
                    .eraseToAnyPublisher()
        }
    
    @State var title:String = ""
    @State var description:String = ""
    @State var phone:String = ""
    @State var email:String = ""
    @State var adType:AdvertTypeEnum = .other
    @State var coord = CLLocationCoordinate2D(latitude: 41.03322, longitude: 29.00000)
    @State var isLocationSet:Bool = false
    @State var placemark:CLPlacemark? = nil
    @State var isUploadPhotosPresent:Bool = false
    @State var images:[UIImage] = []
    
    
    @Binding var stackIsActive:Bool
    
    var body: some View {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title, axis: .vertical).lineLimit(1...2)
                    TextField("Description", text: $description, axis: .vertical).lineLimit(1...4)
                    
                    Picker("Select Advert Type", selection: $adType) {
                        ForEach(AdvertTypeEnum.allCases, id: \.self) { type in
                            Text(enumStrings[type.rawValue]).tag(type)
                        }
                    }
                    //                    .pickerStyle(PalettePickerStyle())
                }
                
                Section(header: Text("Contact Info")) {
                    TextField("Phone",text: $phone)
                        .keyboardType(.phonePad).autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("E-mail",text: $email)
                        .keyboardType(.emailAddress).autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    NavigationLink{
                        SelectLocationView(coord:$coord, isSet: $isLocationSet, address: $placemark)
                    } label:{
                        Text((isLocationSet) ? "Edit Location" : "Select Location")
                    }
                    
                    if let placemark = placemark {
                        Text("\(placemark.name ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "") \(placemark.country ?? "")")
                    }
                    NavigationLink{
                        AddImagesView(selectedImages: $images)
                    } label:{
                        Text((images.isEmpty) ? "Select Images" : "Edit Images(\(images.count))")
                    }
                    
                }                
                
                
            }
            .overlay(){
                if (advertViewModel.isLoading || imageViewModel.isLoading){
                    ProgressView("Uploading")
                        .progressViewStyle(CircularProgressViewStyle()
                        ).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).background(
                    .ultraThickMaterial.opacity(0.8)
                )
                            
                }
            }
            .onChange(of: advertViewModel.advert){initial, changed in
                if let advert = changed {
                    imageViewModel.uploadedImages = images
                    imageViewModel.uploadImages(adId: advert._id){result in
                        switch(result){
                            case .success(_):
                            stackIsActive.toggle()
                            case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .navigationBarTitle("Create New Ad")
            .navigationBarItems(trailing:
                                    Button(action: {
                if let placemark = placemark{
                    Task{
                        advertViewModel.uploadData(advertRequest: AdvertRequest(
                            title: title,
                            description: description,
                            adType: adType,
                            price: 99.0,
                            email: email,
                            phone: phone,
                            location: Location(lat: coord.latitude, lon: coord.longitude),
                            address: Address(
                                country: placemark.country ?? "N/A",
                                zipCode: placemark.postalCode ?? "N/A",
                                city: placemark.administrativeArea ?? "N/A",
                                town: placemark.subAdministrativeArea ?? "N/A",
                                rest: "\(placemark.thoroughfare ?? ""),  \(placemark.subThoroughfare ?? "")")))
//                        if let advert = advertViewModel.advert{
//                            imageViewModel.uploadedImages = images
//                            imageViewModel.uploadImages(adId: advert._id){result in
//                                switch(result){
//                                    case .success(_ ):
//                                        stackIsActive = false
//                                    case .failure(let error):
//                                    print(error.localizedDescription)
//                                }
//                            
//                            }
//                        }
//                        else {
//                            print("No Advert or photos")
//                        }
                    }
                }
                print("Submit button tapped")
            }) {
                HStack{
                    Text("Submit")
                    Image(systemName: "chevron.right")
                }
                
            }
            )
    }
    
}
    

#Preview {
    CreateAdView(stackIsActive: .constant(true))
}
