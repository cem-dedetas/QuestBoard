//
//  LikeButtonComponent.swift
//  test
//
//  Created by Cem Dedetas on 29.10.2023.
//

import SwiftUI

struct LikeButtonComponent: View {
    let adId:String
    @StateObject var advertViewModel = SingleAdvertViewModel()
    @State var isFavorited:Bool
    @State var scaleFactor:CGFloat = 1.2
    var body: some View {
        Image(systemName: (isFavorited) ? "heart.fill" : "heart").onTapGesture{
                if(isFavorited){
                    advertViewModel.removeFromFavorites(id:adId)
                }
                else{
                    advertViewModel.addToFavorites(id:adId)
                }
            withAnimation(.snappy){
                isFavorited.toggle()
                scaleFactor += isFavorited ? 0.7 : -0.5
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.snappy){
                    scaleFactor = 1.2
                    
                }
            }
        }.scaleEffect(scaleFactor)
        .tint( isFavorited ? .red : .primary )
    }
}
