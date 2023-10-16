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
    
    var advertIDPublisher: AnyPublisher<String, Never> {
            NotificationCenter.default.publisher(for: Notification.Name("AdvertIDReceived"))
                .compactMap { $0.object as? String }
                .eraseToAnyPublisher()
    }
    
    @StateObject var viewModel = SingleAdvertViewModel()
    
    
    @State var title:String = ""
    @State var description:String = ""
    @State var phone:String = ""
    @State var email:String = ""
    @State var adType:AdvertTypeEnum = .realEstate
    @State var coord = CLLocationCoordinate2D(latitude: 41.03322, longitude: 29.00000)
    @State var isLocationSet:Bool = false
    @State var placemark:CLPlacemark? = nil
    @State var filesUploaded:Bool = false
    
    @State private var isImageUploadView = false
    @State private var advertID: String = "" // Store the advert ID
    
    @Binding var stackIsActive:Bool
    
    var body: some View {
        Form {
            if viewModel.isLoading{
                VStack{
                    ProgressView("Creating...")
                }
            }
            else{
                Section(header: Text("Details")) {
                    TextField("Title", text: $title, axis: .vertical).lineLimit(1...2)
                    TextField("Description", text: $description, axis: .vertical).lineLimit(3...10)

                    Picker("Type", selection: $adType) {
                        ForEach(AdvertTypeEnum.allCases, id:\.rawValue){type in
                            Text(enumStrings[type.rawValue])
                        }
                    }
                }
                
                Section(header: Text("Contact Info")) {
                    iPhoneNumberField("Phone", text: $phone)
                        .defaultRegion("+90")
                    TextField("E-mail",text: $email)
                        .keyboardType(.emailAddress).autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    NavigationLink{
                        SelectLocationView(coord:$coord, isSet: $isLocationSet, address: $placemark)
                    } label:{
                        Text((isLocationSet) ? "Update Location" : "Select Location")
                    }
                    
                    if let placemark = placemark {
                        Text("\(placemark.name ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "") \(placemark.country ?? "")")
                    }
                    
                }
            }
            
        }
        .onReceive(advertIDPublisher) { id in
            advertID = id
            isImageUploadView = true
        }
        .navigationDestination(isPresented: $isImageUploadView){
            AddImagesView(advertId:advertID, stackIsActive: $stackIsActive)
        }
        .navigationBarTitle("Create New Ad")
        .navigationBarItems(trailing:
            Button(action: {
                if let placemark = placemark{
                    Task{
                        viewModel.uploadData(advertRequest: AdvertRequest(
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
