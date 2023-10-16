//
//  DetailSheetView.swift
//  test
//
//  Created by Cem Dedetas on 23.09.2023.
//

import SwiftUI

struct DetailSheetView: View {
    @Binding var advert:Advert?
    @Binding var isAdDetailPresented:Bool
    @Binding var routeDisplaying:Bool
    @State var sheetRatio = 0.60
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
    VStack {
        if let advert = advert {
                VStack(alignment:.leading){
                    HStack(alignment:.top){
                        Button{
                            dismiss()
                        } label:{
                            HStack{
                                Image(systemName: "chevron.down")
                                Text("Back")
                            }
                        }
                    Spacer()
                        Button{
                            dismiss()
                            isAdDetailPresented.toggle()
                        } label:{
                            HStack{
                                Text("Details")
                                Image(systemName: "chevron.right")
                            }
                        }
                    }.padding()
                    Section{
                        HStack {
                            VStack(alignment: .leading) {
                                Text(advert.title).font(.title)
                            
                            Text("\(enumStrings[advert.adType.rawValue])").foregroundStyle(.gray)
                            }.padding(.horizontal)
                            Spacer()
                            if let address = advert.address {
                                VStack(alignment: .trailing) {
                                    Text(address.country)
                                    
                                    Text("\(address.city) / \(address.town)").foregroundStyle(.gray)
                                }.padding(.horizontal)
                            }
                        }
                    }
                    Section{
                        Text(advert.description).lineLimit(3).italic().padding()
                    }
                    Section {
                        Button{
                            routeDisplaying = true
                        } label: {
                            Text("Get Directions").padding().background(.regularMaterial).clipShape(.capsule)
                        }
                    }
                    Spacer()
                }.navigationTitle(advert.title).navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.fraction(sheetRatio)])
                
                
            }
            
        }
        
    }
}
    



