//
//  DetailSheetView.swift
//  test
//
//  Created by Cem Dedetas on 23.09.2023.
//

import SwiftUI

struct DetailSheetView: View {
    @Binding var advert:Advert
    @State var sheetRatio = 0.60
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            NavigationView {
                VStack{
                    Spacer()
                    Text(advert.title)
                    Text(advert.description)
                    Spacer()
                    NavigationLink{
                        AdDetailsView(adId:advert._id)
                    } label:{
                        Text("Open details fullscreen")
                    }
                    Spacer()
                }.toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button{
                            dismiss()
                        } label:{
                            HStack{
                                Image(systemName: "chevron.down")
                                Text("Back")
                            }
                        }
                    }
                }
                
                
                
            }
            .presentationDetents([.fraction(sheetRatio)])

    }
}

#Preview {
    DetailSheetView(advert: .constant(Advert(id: UUID().uuidString, title: "AppleHQ", adType: AdvertTypeEnum.realEstate, description: "Description", price: 99, email: "cemdedetas@gmail.com", imgURLs: [""], phone: "+905555555", createdAt: Date().formatted(), location: Location(lat: 37.3317, lon: -122.0307))))
}
